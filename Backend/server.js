const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const bcrypt = require("bcrypt");

const app = express();
app.use(express.json());
app.use(cors());

// Connect to MongoDB
mongoose.connect("mongodb://127.0.0.1:27017/shoppingDB", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log("✅ Connected to MongoDB"))
  .catch(err => console.error("❌ MongoDB Connection Error:", err));

// Item Schema
const ItemSchema = new mongoose.Schema({
  name: String,
  quantity: Number,
  price: Number,
  date: { type: Date, default: Date.now },
});

const Item = mongoose.model("Item", ItemSchema);

// Add Item
app.post("/addItem", async (req, res) => {
  try {
    const { name, quantity, price } = req.body;
    const newItem = new Item({ name, quantity, price });
    await newItem.save();
    res.json({ message: "✅ Item added successfully!" });
  } catch (error) {
    res.status(500).json({ message: "❌ Error adding item", error });
  }
});

// Get Items
app.get("/getItems", async (req, res) => {
  try {
    const items = await Item.find().sort({ date: -1 });
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: "❌ Error fetching items", error });
  }
});

// Weekly Price Comparison
app.get("/weeklyComparison", async (req, res) => {
  try {
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
  } catch (error) {
    res.status(500).json({ message: "❌ Error fetching comparison", error });
  }
});

// Delete Item
app.delete("/deleteItem/:id", async (req, res) => {
  try {
    const itemId = req.params.id;

    if (!mongoose.Types.ObjectId.isValid(itemId)) {
      return res.status(400).json({ message: "❌ Invalid item ID format" });
    }

    const result = await Item.findByIdAndDelete(itemId);
    if (result) {
      res.json({ message: "✅ Item deleted successfully", deletedItem: result });
    } else {
      res.status(404).json({ message: "❌ Item not found" });
    }
  } catch (error) {
    res.status(500).json({ message: "❌ Error deleting item", error });
  }
});

// User Schema
const UserSchema = new mongoose.Schema({
  username: { type: String, unique: true, required: true },
  password: { type: String, required: true },
});

const User = mongoose.model("User", UserSchema);

// Signup
app.post("/signup", async (req, res) => {
  try {
    const { username, password } = req.body;
    const existingUser = await User.findOne({ username });

    if (existingUser) {
      return res.status(400).json({ message: "❌ Username already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({ username, password: hashedPassword });
    await newUser.save();
    
    res.json({ message: "✅ User registered successfully!" });
  } catch (error) {
    res.status(500).json({ message: "❌ Error registering user", error });
  }
});

// Login
app.post("/login", async (req, res) => {
  try {
    const { username, password } = req.body;
    const user = await User.findOne({ username });

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ message: "❌ Invalid username or password" });
    }

    res.json({ message: "✅ Login successful!" });
  } catch (error) {
    res.status(500).json({ message: "❌ Error logging in", error });
  }
});

// Start Server
app.listen(5050, () => console.log("🚀 Server running on port 5050"));
