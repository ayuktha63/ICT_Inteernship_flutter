const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

mongoose.connect("mongodb://localhost:27017/shoppingDB", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const ItemSchema = new mongoose.Schema({
  name: String,
  quantity: Number,
  price: Number,
  date: { type: Date, default: Date.now },
});

const Item = mongoose.model("Item", ItemSchema);

app.post("/addItem", async (req, res) => {
  const { name, quantity, price } = req.body;
  const newItem = new Item({ name, quantity, price });
  await newItem.save();
  res.json({ message: "Item added successfully!" });
});

app.get("/getItems", async (req, res) => {
  const items = await Item.find().sort({ date: -1 });
  res.json(items);
});

app.get("/weeklyComparison", async (req, res) => {
  const items = await Item.aggregate([
    {
      $group: {
        _id: "$name",
        averagePrice: { $avg: "$price" },
        latestPrice: { $last: "$price" },
        previousPrice: { $first: "$price" },
      },
    },
  ]);
  res.json(items);
});
app.delete("/deleteItem/:id", async (req, res) => {
    try {
      const itemId = req.params.id;
      console.log("Deleting Item ID:", itemId);
  
      if (!mongoose.Types.ObjectId.isValid(itemId)) {
        return res.status(400).json({ message: "Invalid item ID format" });
      }
  
      const result = await Item.findByIdAndDelete(itemId);
      if (result) {
        res.json({ message: "Item deleted successfully", deletedItem: result });
      } else {
        res.status(404).json({ message: "Item not found" });
      }
    } catch (error) {
      res.status(500).json({ message: "Error deleting item", error });
    }
  });
  
app.listen(5050, () => console.log("Server running on port 5050"));
