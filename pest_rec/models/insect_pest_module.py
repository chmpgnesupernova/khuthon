from typing import Any, Dict, Optional, Tuple

import torch
from lightning import LightningModule
from torch import nn
from torch.nn import functional as F
from torchmetrics import Accuracy

from pest_rec.models.components.insect_pest_net import InsectPestClassifier


class InsectPestLitModule(LightningModule):
    def __init__(
        self,
        net: nn.Module,
        optimizer: torch.optim.Optimizer,
        scheduler: Optional[torch.optim.lr_scheduler._LRScheduler] = None,
    ) -> None:
        super().__init__()
        self.save_hyperparameters(ignore=["net"])
        self.net = net
        self.criterion = nn.CrossEntropyLoss()
        self.train_acc = Accuracy(task="multiclass", num_classes=102)
        self.val_acc = Accuracy(task="multiclass", num_classes=102)
        self.test_acc = Accuracy(task="multiclass", num_classes=102)

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.net(x)

    def step(self, batch: Any) -> Tuple[torch.Tensor, torch.Tensor, torch.Tensor]:
        x, y = batch
        logits = self.forward(x)
        loss = self.criterion(logits, y)
        preds = torch.argmax(logits, dim=1)
        return loss, preds, y

    def training_step(self, batch: Any, batch_idx: int) -> torch.Tensor:
        loss, preds, targets = self.step(batch)
        self.train_acc(preds, targets)
        self.log("train/loss", loss, on_step=False, on_epoch=True, prog_bar=True)
        self.log("train/acc", self.train_acc, on_step=False, on_epoch=True, prog_bar=True)
        return loss

    def validation_step(self, batch: Any, batch_idx: int) -> None:
        loss, preds, targets = self.step(batch)
        self.val_acc(preds, targets)
        self.log("val/loss", loss, on_step=False, on_epoch=True, prog_bar=True)
        self.log("val/acc", self.val_acc, on_step=False, on_epoch=True, prog_bar=True)

    def test_step(self, batch: Any, batch_idx: int) -> None:
        loss, preds, targets = self.step(batch)
        self.test_acc(preds, targets)
        self.log("test/loss", loss, on_step=False, on_epoch=True)
        self.log("test/acc", self.test_acc, on_step=False, on_epoch=True)

    def configure_optimizers(self) -> Dict[str, Any]:
        optimizer = self.hparams.optimizer(params=self.parameters())
        if self.hparams.scheduler is None:
            return {"optimizer": optimizer}
        scheduler = self.hparams.scheduler(optimizer=optimizer)
        return {
            "optimizer": optimizer,
            "lr_scheduler": {
                "scheduler": scheduler,
                "monitor": "val/acc",
                "frequency": 1,
                "interval": "epoch",
            },
        }
