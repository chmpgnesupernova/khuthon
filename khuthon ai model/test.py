import unittest
from unittest.mock import patch, MagicMock
from pathlib import Path
import torch
import builtins

from test_inference import predict_one


class TestPestPrediction(unittest.TestCase):

    @patch("your_script_file.Image.open")  
    @patch("your_script_file.InsectPestLitModule.load_from_checkpoint")
    @patch("your_script_file.InsectPestClassifier")
    def test_predict_one_basic(
        self, mock_classifier, mock_load_ckpt, mock_image_open
    ):
        dummy_classes = ["pest1", "pest2", "pest3"]
        dummy_class_file = Path("dummy_classes.txt")

        with patch.object(builtins, "open", unittest.mock.mock_open(read_data="\n".join(dummy_classes))):

            mock_model = MagicMock()
            mock_model.eval = MagicMock()
            mock_model.to = MagicMock()
            mock_model.return_value = torch.tensor([[0.1, 0.2, 0.7]])
            mock_load_ckpt.return_value = mock_model

            dummy_img = MagicMock()
            mock_image_open.return_value.convert.return_value = dummy_img

            predict_one(
                ckpt_path=Path("dummy.ckpt"),
                image_path=Path("image.jpg"),
                classes_path=dummy_class_file,
                img_size=224
            )

            mock_classifier.assert_called_once()
            mock_load_ckpt.assert_called_once()
            mock_model.eval.assert_called_once()
            mock_model.to.assert_called_once()

    def test_get_device_cpu(self):
        from test_inference import get_device
        device = get_device()
        self.assertIn(str(device), ["cpu", "cuda", "mps"])

 
if __name__ == "__main__":
    unittest.main()
