# 🛒 Shopping List App

A **Flutter** mobile application that allows users to **add, view, and delete shopping items**, backed by a **Node.js & MongoDB** server.

## 📌 Features
✅ **Add Items** (Name, Quantity, Price)  
✅ **View Items** (Fetched from MongoDB)  
✅ **Delete Items** (Removes from MongoDB & UI)  
✅ **Real-Time Updates** (Auto-refresh after actions)  
✅ **REST API Integration** (Node.js & Express)

---

## 🚀 Tech Stack

### 🖥️ Backend: Node.js + MongoDB
- **Express.js** - API Server
- **Mongoose** - MongoDB ORM
- **MongoDB** - Database (Local or Atlas)

### 📱 Frontend: Flutter
- **Flutter Framework** - UI
- **Dart** - Programming Language
- **HTTP Package** - API Calls

---

## 📌 Installation Guide

### 1️⃣ Install Dependencies

#### 📌 Backend (Node.js)
```sh
git clone https://github.com/ayuktha63/ICT_Inteernship_flutter.git
cd shopping-list-app/backend
npm install
```

#### 📌 Frontend (Flutter)
```sh
cd shopping-list-app/frontend
flutter pub get
```

---

### 2️⃣ Start MongoDB
If using a **local database**, run:
```sh
mongod --dbpath ~/mongodb_data
```
If using **MongoDB Atlas**, update `server.js` with your connection string.

---

### 3️⃣ Start Backend Server
```sh
cd backend
node server.js
```
Server runs on: `http://192.168.1.2:5050/`

---

### 4️⃣ Run Flutter App
```sh
cd frontend
flutter run
```

---
## ScreenShots
<img src="https://github.com/ayuktha63/ICT_Inteernship_flutter/blob/main/Screenshots/InsightsPage.png" width="300"> <img src="https://github.com/ayuktha63/ICT_Inteernship_flutter/blob/main/Screenshots/MainPage.png" width="300"> <img src="https://github.com/ayuktha63/ICT_Inteernship_flutter/blob/main/Screenshots/ScanPage.png" width="300">


## 📌 API Endpoints

| Method | Endpoint | Description |
|--------|----------|------------|
| **POST** | `/addItem` | Add a new item |
| **GET** | `/getItems` | Get all items |
| **DELETE** | `/deleteItem/:id` | Delete an item |


## 📌 Contributors
- **Ayuktha63** - [GitHub](https://github.com/ayuktha63)
- **Aleena Shaji** - [GitHub](https://github.com/Aleenashaji242)

---

## 📌 License
This project is licensed under the **MIT License**.

---

🎉 **Happy Coding!** 🚀
