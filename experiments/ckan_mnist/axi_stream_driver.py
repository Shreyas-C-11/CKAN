from datetime import datetime

import numpy as np
from pynq import Overlay, allocate


class NeuralNetworkOverlay(Overlay):
    def __init__(
        self, bitfile_name, x_shape, y_shape, input_dtype=np.uint8, output_dtype=np.int16, dtbo=None, download=True, ignore_version=False, device=None
    ):
        super().__init__(bitfile_name, dtbo=dtbo, download=download, ignore_version=ignore_version, device=device)

        self.input_shape = tuple(x_shape[1:]) if len(x_shape) > 1 else tuple(x_shape)
        self.output_shape = tuple(y_shape[1:]) if len(y_shape) > 1 else tuple(y_shape)
        self.input_dtype = input_dtype
        self.output_dtype = output_dtype

        dma = self._resolve_dma()
        self.sendchannel = dma.sendchannel
        self.recvchannel = dma.recvchannel
        self.input_buffer = allocate(shape=self.input_shape, dtype=input_dtype)
        self.output_buffer = allocate(shape=self.output_shape, dtype=output_dtype)

    def _resolve_dma(self):
        candidates = (
            ("hier_0", "axi_dma_0"),
            ("axi_dma_0",),
            ("hier_0", "axi_dma"),
            ("axi_dma",),
        )

        for path in candidates:
            node = self
            try:
                for name in path:
                    node = getattr(node, name)
                return node
            except AttributeError:
                continue

        for name in self.ip_dict:
            if "axi_dma" in name:
                node = self
                for part in name.replace("/", ".").split("."):
                    if not part:
                        continue
                    node = getattr(node, part)
                return node

        raise AttributeError("Could not locate an AXI DMA block in the loaded overlay")

    def _print_dt(self, timea, timeb, N):
        dt = timeb - timea
        dts = dt.seconds + dt.microseconds * 10**-6
        rate = N / dts
        print(f"Classified {N} samples in {dts} seconds ({rate} inferences / s)")
        return dts, rate

    def predict(self, X, debug=False, profile=False, encode=None, decode=None):
        """
        Obtain the predictions of the NN implemented in the FPGA.
        Parameters:
        - X : the input vector. Should be numpy ndarray.
        - dtype : the data type of the elements of the input/output vectors.
                  Note: it should be set depending on the interface of the accelerator; if it uses 'float'
                  types for the 'data' AXI-Stream field, 'np.float32' dtype is the correct one to use.
                  Instead if it uses 'ap_fixed<A,B>', 'np.intA' is the correct one to use (note that A cannot
                  any integer value, but it can assume {..., 8, 16, 32, ...} values. Check `numpy`
                  doc for more info).
                  In this case the encoding/decoding has to be computed by the PS. For example for
                  'ap_fixed<16,6>' type the following 2 functions are the correct one to use for encode/decode
                  'float' -> 'ap_fixed<16,6>':
                  ```
                    def encode(xi):
                        return np.int16(round(xi * 2**10)) # note 2**10 = 2**(A-B)
                    def decode(yi):
                        return yi * 2**-10
                    encode_v = np.vectorize(encode) # to apply them element-wise
                    decode_v = np.vectorize(decode)
                  ```
        - profile : boolean. Set it to `True` to print the performance of the algorithm in term of `inference/s`.
        - encode/decode: function pointers. See `dtype` section for more information.
        - return: an output array based on `np.ndarray` with a shape equal to `y_shape` and a `dtype` equal to
                  the namesake parameter.
        """
        if profile:
            timea = datetime.now()
        X = np.asarray(X)

        if X.shape == self.input_shape:
            samples = [X]
        elif X.ndim == len(self.input_shape) + 1:
            samples = list(X)
        else:
            samples = [X.reshape(self.input_shape)]

        outputs = []
        for sample in samples:
            sample_to_send = encode(sample) if encode is not None else sample
            self.input_buffer[:] = np.asarray(sample_to_send).reshape(self.input_shape)
            self.sendchannel.transfer(self.input_buffer)
            self.recvchannel.transfer(self.output_buffer)
            if debug:
                print("Transfer OK")
            self.sendchannel.wait()
            if debug:
                print("Send OK")
            self.recvchannel.wait()
            if debug:
                print("Receive OK")

            result = self.output_buffer.copy()
            if decode is not None:
                result = decode(result)
            outputs.append(result)

        if len(outputs) == 1:
            output = outputs[0]
        else:
            output = np.stack(outputs, axis=0)

        if profile:
            timeb = datetime.now()
            dts, rate = self._print_dt(timea, timeb, len(samples))
            return output, dts, rate

        return output
