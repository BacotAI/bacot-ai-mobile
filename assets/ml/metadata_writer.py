
import os
from tflite_support.metadata_writers import object_detector
from tflite_support.metadata_writers import writer_utils

# Path to your existing TFLite model
_MODEL_PATH = "mask_detector.tflite"
# Path where the new model with metadata will be saved
_SAVE_TO_PATH = "mask_detector_with_metadata.tflite"

# Define the normalization parameters for the input image
# For models trained with input range [-1, 1], mean is 127.5 and std is 127.5
_INPUT_NORM_MEAN = 127.5
_INPUT_NORM_STD = 127.5

# Label file path (optional, create if you have labels)
# For object detection, labels are usually required.
# Create a file named 'labels.txt' with the class names (one per line)
_LABEL_FILE = "labels.txt"

def populate_metadata():
    """Populates the metadata for an object detector model."""

    # Create the writer
    writer = object_detector.MetadataWriter.create_for_inference(
        writer_utils.load_file(_MODEL_PATH),
        [_INPUT_NORM_MEAN],
        [_INPUT_NORM_STD],
        [_LABEL_FILE]  # Pass [None] if you don't have a label file, but highly recommended for OD
    )

    print(f"Writing model to {_SAVE_TO_PATH}...")
    writer_utils.save_file(writer.populate(), _SAVE_TO_PATH)
    print("Metadata populated successfully!")


if __name__ == "__main__":
    if not os.path.exists(_LABEL_FILE):
        with open(_LABEL_FILE, "w") as f:
            f.write("mask\n") 
            f.write("no_mask\n")
        print(f"Created dummy {_LABEL_FILE}. Please update it with correct labels if needed.")

    if not os.path.exists(_MODEL_PATH):
        print(f"Error: '{_MODEL_PATH}' not found. Please place your .tflite model in this directory.")
    else:
        populate_metadata()
