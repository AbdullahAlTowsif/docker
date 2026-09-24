# DHCP Discover | Break Into Pieces | DORA Part 1

This class is a deep dive into the **first step** of the DORA process — the **DHCP Discover** packet.  
We break the packet into pieces so you can clearly understand every field and why it exists.

---

## Recap – Where We Are in the Story

From previous classes:

1. You bought a computer and attached a NIC → got a temporary APIPA IP.
2. You bought a router → it has a pre-configured LAN IP (e.g. `192.168.1.1`).
3. You connected the computer to the router with an Ethernet cable.
4. The computer needs a real IP from the router’s DHCP server.

**Problem:**  
The computer does **not** know:
- The router’s IP address
- The router’s MAC address

**Solution:**  
It sends a special broadcast packet called **DHCP Discover**.

---

## What is DHCP Discover?

**DHCP Discover** is the very first message a client sends when it wants to get an IP address from a DHCP server.

- It is a **broadcast** message.
- Destination IP = `255.255.255.255`
- Destination MAC = `FF:FF:FF:FF:FF:FF`
- Source IP = `0.0.0.0` (because the client has no real IP yet)

This packet reaches **every device** on the local network. Only the DHCP server (the router) replies.

---

## DHCP Discover Packet Structure (Broken Into Pieces)

A DHCP Discover message sits inside a UDP packet, which sits inside an IP packet, which sits inside an Ethernet Frame.

### 1. Ethernet Header (Data Link Layer)

| Field                  | Value                          | Explanation |
|------------------------|--------------------------------|-----------|
| Destination MAC        | `FF:FF:FF:FF:FF:FF`            | Broadcast MAC – send to everyone |
| Source MAC             | Client’s own MAC address       | The computer’s NIC MAC |
| EtherType              | `0x0800`                       | Means the next layer is IPv4 |

### 2. IP Header (Network Layer)

| Field                  | Value                          | Explanation |
|------------------------|--------------------------------|-----------|
| Source IP              | `0.0.0.0`                      | Client has no IP yet |
| Destination IP         | `255.255.255.255`              | Limited Broadcast address |
| Protocol               | UDP (17)                       | DHCP runs on UDP |
| TTL                    | Usually 64 or 128              | Time To Live |

### 3. UDP Header (Transport Layer)

| Field                  | Value                          | Explanation |
|------------------------|--------------------------------|-----------|
| Source Port            | **68**                         | DHCP Client port |
| Destination Port       | **67**                         | DHCP Server port |

**Important:**  
- Client always uses port **68**
- Server always uses port **67**

### 4. DHCP Message Body (Application Layer)

This is the actual DHCP Discover content.

#### Common Fields in DHCP Discover:

| Field                  | Typical Value                  | Meaning |
|------------------------|--------------------------------|---------|
| **Opcode (op)**        | 1                              | 1 = Boot Request (from client) |
| **Hardware Type (htype)** | 1                           | 1 = Ethernet |
| **Hardware Length (hlen)** | 6                          | MAC address is 6 bytes |
| **Hops**               | 0                              | Number of relay agents (0 = direct) |
| **Transaction ID (xid)** | Random 32-bit number         | Used to match request with reply |
| **Seconds**            | 0                              | Time since client started trying |
| **Flags**              | 0x8000 (Broadcast flag)        | Tell server to reply with broadcast |
| **Client IP (ciaddr)** | `0.0.0.0`                      | Client’s current IP (none yet) |
| **Your IP (yiaddr)**   | `0.0.0.0`                      | IP offered by server (empty in Discover) |
| **Server IP (siaddr)** | `0.0.0.0`                      | DHCP server IP (unknown yet) |
| **Gateway IP (giaddr)**| `0.0.0.0`                      | Relay agent IP (none) |
| **Client Hardware Address (chaddr)** | Client’s MAC address | The real identity of the client |
| **Magic Cookie**       | `99.130.83.99`                 | Identifies this as a DHCP packet |
| **Options**            | See below                      | Extra information |

---

## Important DHCP Options in Discover

The client tells the server what information it wants using **Options**:

| Option Number | Name                        | Meaning |
|---------------|-----------------------------|---------|
| 53            | DHCP Message Type           | Value = 1 → DHCP Discover |
| 55            | Parameter Request List      | What the client wants (Subnet Mask, Router, DNS, Lease Time, etc.) |
| 61            | Client Identifier           | Usually the MAC address |
| 50            | Requested IP Address        | (Optional) Client can suggest an IP |
| 12            | Hostname                    | Computer’s name (optional) |

---

## Why Broadcast?

Because the client knows **nothing**:

- It does not know any DHCP server’s IP
- It does not know any MAC address of a DHCP server
- It only knows its own MAC address

So the only possible way is:

```
Destination IP  = 255.255.255.255
Destination MAC = FF:FF:FF:FF:FF:FF
```

This is called a **Limited Broadcast**.

---

## What Happens After DHCP Discover?

1. The packet is sent out on the wire.
2. Every device on the local network receives it.
3. Only the **DHCP Server** (usually the router) understands it and replies with a **DHCP Offer**.
4. All other devices simply ignore the packet.

---

## Visual Summary of the Discover Packet

```
┌─────────────────────────────────────────────┐
│ Ethernet Header                             │
│  Dest MAC: FF:FF:FF:FF:FF:FF                │
│  Src  MAC: Client’s MAC                     │
├─────────────────────────────────────────────┤
│ IP Header                                   │
│  Src IP:  0.0.0.0                           │
│  Dest IP: 255.255.255.255                   │
├─────────────────────────────────────────────┤
│ UDP Header                                  │
│  Src Port: 68                               │
│  Dest Port: 67                              │
├─────────────────────────────────────────────┤
│ DHCP Discover Message                       │
│  - Transaction ID (random)                  │
│  - Client MAC Address                       │
│  - Options: Message Type = Discover         │
│  - Parameter Request List                   │
└─────────────────────────────────────────────┘
```

---

## Key Takeaways

- DHCP Discover is the **first** message in the DORA process.
- It is always a **broadcast**.
- Source IP is always `0.0.0.0`.
- Destination IP is always `255.255.255.255`.
- Destination MAC is always `FF:FF:FF:FF:FF:FF`.
- Client uses UDP port **68**, Server uses UDP port **67**.
- The Transaction ID is very important — it is used to match the Offer that will come back.
- The client’s real identity is its **MAC address**.

---

## What Comes Next

In the next class we will break the **DHCP Offer** packet into pieces (the second step of DORA).

---

**End of Class Notes**

This document contains every important field, value, and explanation related to the **DHCP Discover** packet as taught in the video.
