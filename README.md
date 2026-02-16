CKAN_Layer (wrapper)
├── Conv2D_KAN
│   ├── ImageBufferChnl (×1)
│   │   └── ImageBuf_KernelSlider (×Cin)
│   │       └── Line_Buffer → Data_Buffer
│   └── ConvolChnl_KAN
│       └── Conv_MIC_KAN (×Cout)
│           └── Conv_SIC_KAN (×Cin)
│               └── KAN_LUT_ROM (×K²)
└── MaxPool2D
    ├── ImageBufferChnl (×1, reused for pooling windows)
    │   └── ImageBuf_KernelSlider (×Cout)
    │       └── Line_Buffer → Data_Buffer
    └── MaxPooling (×Cout)
