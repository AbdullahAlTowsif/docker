# 🌐 OSI Model

**OSI** → **O**pen **S**ystem **I**nterconnection
Invented in **1984** by **ISO** (International Organization for Standardization)

### 🔤 Breaking Down the Name

| Word | Meaning |
|------|---------|
| **Open** | Any (system, vendor, or platform) |
| **System** | Components, resource sharing |
| **Interconnection** | Communicating with any system |

---

## 🧠 The 7 Layers (Memory Trick)

> **Please Do Not Tell Secret Password to Anyone**

| Layer | Name | Mnemonic Word |
|:---:|------|:---:|
| **7** | Application Layer | Anyone |
| **6** | Presentation Layer | Password |
| **5** | Session Layer | Secret |
| **4** | Transport Layer | Tell |
| **3** | Network Layer | Not |
| **2** | Data Link Layer | Do |
| **1** | Physical Layer | Please |

> ⭐ **Most important layers:** Layer 2 (Data Link), Layer 4 (Transport), Layer 7 (Application)

---

## 📖 The Journey of Data: Sender → Receiver

**Scenario:** Computer 1 (Sender) sends "Hello" to Computer 2 (Receiver) via Facebook.

### 🖥️ Computer 1 — Sender's Side

**1️⃣ Application Layer**
Facebook sends the message → `Hello`

**2️⃣ Presentation Layer**
The computer can't understand plain "Hello" as-is, so it **formats the data** into a standard format such as `json`, `xml`, `yaml`, `png`, `jpg`, `webp`, `mp4`, `mp3`, etc.

```json
{ "data": "Hello" }
```

**3️⃣ Session Layer**
Manages the **connection** between sender and receiver — keeping it alive, ending it, or handling it as needed.

**4️⃣ Transport Layer**
Converts the data into **segments**, adding sender & receiver **ports**:

```
[s_port:3000 { data } r_port:5000]   →   Segment
```

**5️⃣ Network Layer**
Converts the segment into a **packet**, adding sender & receiver **IP addresses**:

```
[s_ip:192.168.10.05 { segment } r_ip:192.168.10.06]   →   Packet
```

**6️⃣ Data Link Layer**
Converts the packet into a **frame**, adding sender & receiver **MAC addresses**:

```
[s_mac_addr { packet } r_mac_addr]   →   Frame
```

**7️⃣ Physical Layer**
Converts the frame into raw **bits** (`110101011`) and transmits them to the receiver.

---

### 🖥️ Computer 2 — Receiver's Side

The exact **reverse** process happens:

```
Bits  →  Frame  →  Packet  →  Segment  →  Data (JSON)
```

The JSON is decoded, and the receiver finally sees:

```
Hello
```

---

## 🔄 Visual Flow Summary

| Direction | Sender (Computer 1) | Receiver (Computer 2) |
|-----------|----------------------|-------------------------|
| ⬇️ Encapsulation | Data → Segment → Packet → Frame → Bits | — |
| ⬆️ Decapsulation | — | Bits → Frame → Packet → Segment → Data |

---

## 🛰️ Protocols at Each Layer

| Layer | Common Protocols |
|-------|-------------------|
| **Application** | HTTP, HTTPS, SSH, SMTP, FTP, SFTP |
| **Presentation** | UTF-8, SSL/TLS, Compression, Conversion |
| **Session** | *(Manages sessions — no single dominant protocol)* |
| **Transport** | TCP, UDP |
| **Network** | IP |
| **Data Link** | Ethernet, ARP, Wi-Fi |
| **Physical** | *(Cables, radio signals, physical bit transmission)* |

---

*Quick reference notes on the OSI Model — its 7 layers, the encapsulation/decapsulation journey of data, and protocols used at each layer.*
