import os
import shutil
import urllib.request
import zipfile


TINY_IMAGENET_URL = "http://cs231n.stanford.edu/tiny-imagenet-200.zip"


def _write_wnid_folders(val_dir: str, annotations_path: str) -> None:
    image_dir = os.path.join(val_dir, "images")
    if not os.path.isdir(image_dir):
        return

    with open(annotations_path, "r") as handle:
        for line in handle:
            parts = line.strip().split("\t")
            if len(parts) < 2:
                continue
            image_name, wnid = parts[0], parts[1]
            source_path = os.path.join(image_dir, image_name)
            if not os.path.isfile(source_path):
                continue
            target_dir = os.path.join(val_dir, wnid)
            os.makedirs(target_dir, exist_ok=True)
            shutil.move(source_path, os.path.join(target_dir, image_name))

    shutil.rmtree(image_dir, ignore_errors=True)


def ensure_tiny_imagenet(data_root: str) -> str:
    data_root = os.path.abspath(data_root)
    dataset_dir = os.path.join(data_root, "tiny-imagenet-200")
    train_dir = os.path.join(dataset_dir, "train")
    val_dir = os.path.join(dataset_dir, "val")
    annotations_path = os.path.join(val_dir, "val_annotations.txt")

    if os.path.isdir(train_dir) and os.path.isdir(val_dir):
        if os.path.isfile(annotations_path) and os.path.isdir(os.path.join(val_dir, "images")):
            _write_wnid_folders(val_dir, annotations_path)
        return dataset_dir

    os.makedirs(data_root, exist_ok=True)
    archive_path = os.path.join(data_root, "tiny-imagenet-200.zip")

    if not os.path.isfile(archive_path):
        print(f"Downloading TinyImageNet from {TINY_IMAGENET_URL} ...")
        urllib.request.urlretrieve(TINY_IMAGENET_URL, archive_path)

    if not os.path.isdir(dataset_dir):
        print(f"Extracting TinyImageNet into {data_root} ...")
        with zipfile.ZipFile(archive_path, "r") as zip_ref:
            zip_ref.extractall(data_root)

    if os.path.isfile(annotations_path) and os.path.isdir(os.path.join(val_dir, "images")):
        _write_wnid_folders(val_dir, annotations_path)

    return dataset_dir