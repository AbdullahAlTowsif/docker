# Hub | Switch | Router

This class explains the three fundamental network devices: **Hub**, **Switch**, and **Router**.  
It shows how data moves inside a Local Area Network (LAN) and how these devices work at different layers of the OSI model.

---

## 1. Hub (Layer 1 Device)

### What is a Hub?
- A simple, dumb networking device.
- Works only at the **Physical Layer (L1)**.
- Has multiple Ethernet ports (usually 4–8).

### How a Hub Works
1. A computer sends data through its NIC.
2. The data reaches the hub via the connected cable.
3. The hub **cannot** understand:
   - MAC addresses
   - IP addresses
   - Ports
   - Application data
4. It simply takes the electrical signal and **forwards it to all other ports** except the port from which the data arrived.

### Characteristics of Hub
- Completely **blind**.
- Creates a single collision domain.
- Every device receives every packet → unnecessary traffic and collisions.
- Almost obsolete today (replaced by switches).

**Summary:**  
Hub = L1 device → Floods every packet to all ports.

---

## 2. Switch (Layer 2 Device)

### What is a Switch?
- A smart networking device that works at the **Data Link Layer (L2)**.
- Understands **MAC addresses**.
- Has many more ports than a hub (8, 16, 24, 48…).

### How a Switch Works (Step by Step)

#### Step 1: Learning (Building the MAC Address Table)
When a frame arrives on a port:
- Switch reads the **Source MAC** address.
- Records:  
  `Source MAC → Incoming Port`  
  in its internal table.

This table is called:
- **CAM Table** (Content Addressable Memory)
- **MAC Address Table**
- **Forwarding Database**
- **Bridge Table**

(All names refer to the same thing.)

#### Step 2: Forwarding Decision
- Switch looks at the **Destination MAC**.
- If the Destination MAC is already in the table → forwards the frame **only** to that specific port (unicast).
- If the Destination MAC is **not** in the table → **floods** the frame to all ports (except the incoming port). This is called **flooding**.

#### Example
- Computer A (MAC A) connected to Port 1 wants to send data to Computer D (MAC D).
- First time → Switch does not know Port of D → floods to all ports.
- When D replies, Switch learns: `MAC D → Port 4`.
- Next time A sends to D → Switch forwards **only** to Port 4.

### Important Points about Switch
- Works **only** up to Data Link Layer (L2).
- Cannot read IP addresses (Network Layer).
- Very efficient after the table is built.
- Each port is its own collision domain.

**Summary:**  
Switch = L2 device → Learns MAC ↔ Port mapping and forwards intelligently (or floods if unknown).

---

## 3. Router (Layer 3 Device)

### What is a Router?
- Works at the **Network Layer (L3)**.
- Understands **IP addresses**.
- Connects different networks together.

### Home Router Reality
A typical home Wi-Fi router is **not** a pure router.  
It contains **two devices inside one box**:

1. **Switch** (for LAN ports + Wi-Fi)
2. **Router** (the real routing engine)

```
┌──────────────────────────────┐
│        Home Router           │
│  ┌──────────┐   ┌─────────┐  │
│  │  Switch  │───│  Router │  │
│  │ (LAN)    │   │ (L3)    │  │
│  └──────────┘   └─────────┘  │
│     ↑ Ports + Wi-Fi          │
└──────────────────────────────┘
```

- When you plug an Ethernet cable into the router, you are actually plugging into the **internal switch**.
- The real router only gets involved when traffic needs to leave the local network.

### Router Interfaces
- **LAN Interface** → Private IP (e.g. `192.168.1.1`) → Default Gateway
- **WAN Interface** → Public IP (given by ISP when connected to the Internet)

---

## 4. How Devices Decide Destination MAC Address

Before sending a frame, the operating system does this check:

1. Take **Source IP** AND **Subnet Mask** → Network Address of sender
2. Take **Destination IP** AND **Subnet Mask** → Network Address of receiver

### Case A: Same Network
- Network Addresses match → devices are on the **same LAN**.
- Destination MAC = real MAC of the target device.
- Packet stays inside the switch (router is not involved).

### Case B: Different Network
- Network Addresses do **not** match → target is outside the LAN.
- Destination MAC = MAC address of the **Default Gateway** (router’s LAN interface).
- Packet is delivered to the router, which then routes it further.

---

## 5. Complete Communication Example (Same LAN)

1. Computer A wants to talk to Computer C (same network).
2. A creates Application → Transport → Network → Data Link frame.
3. Destination MAC = C’s MAC (because same network).
4. Frame goes to the internal switch of the home router.
5. Switch looks at its CAM table:
   - Learns A’s MAC if needed.
   - Forwards only to the port of C (or floods if unknown).
6. C receives the frame, processes it, and replies.
7. On the reply, Switch learns C’s MAC → next packets are unicast.

**Result:**  
The real router (L3 part) does **not** participate in internal LAN communication.

---

## 6. Summary Table

| Device   | Layer | Understands          | Behavior                              | Used Today? |
|----------|-------|----------------------|---------------------------------------|-------------|
| **Hub**  | L1    | Nothing (only signal)| Floods to all ports                   | Almost never |
| **Switch**| L2   | MAC addresses        | Learns MAC↔Port, unicast or flood     | Everywhere  |
| **Router**| L3  | IP addresses         | Routes between different networks     | Everywhere  |

---

## 7. Key Takeaways

- Hub is dumb and floods everything (L1).
- Switch is smart: builds CAM / MAC Address Table and forwards intelligently (L2).
- Router works with IP addresses and connects different networks (L3).
- A home router = Switch + Router combined.
- Devices decide Destination MAC by checking whether the target is on the same network or not (using IP + Subnet Mask AND operation).
- Internal LAN traffic is handled only by the switch part; the real router is not involved.

---

## What Comes Next

In the next class we will use detailed diagrams to show:
- How data moves between computers inside the same LAN.
- How traffic leaves the LAN and goes to the Internet.

---

**End of Class Notes**

This document captures every important concept, example, and explanation given in the video about Hub, Switch, and Router.
