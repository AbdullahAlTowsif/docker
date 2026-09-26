# DHCP Request & Acknowledge | Break Into Pieces - DORA Part 3

This class completes the **DORA** process by explaining the last two steps in detail:

- **R** → DHCP Request  
- **A** → DHCP Acknowledge (ACK)

We also learn how a private network (LAN) is formed and how the Network Address is calculated.

---

## Recap – DORA So Far

1. **Discover** → Client broadcasts: “I need an IP”
2. **Offer** → Router replies: “I can give you this IP + Subnet Mask + Default Gateway”
3. Now the client must formally request that IP
4. Router must officially confirm (Acknowledge)

---

## 1. DHCP Request (Client → Router)

After receiving the Offer, the client does **not** immediately configure the IP.  
It first sends a **DHCP Request** saying:

> “Yes, I want the IP you offered me. Please assign it to me.”

### Application Layer (Client)

The client prepares:

- Requested IP Address → the IP offered earlier (e.g. `192.168.1.10`)
- Subnet Mask → the one received in Offer
- Default Gateway → the one received in Offer

### Transport Layer (UDP)

| Field              | Value |
|--------------------|-------|
| Source Port        | **68** (DHCP Client) |
| Destination Port   | **67** (DHCP Server) |

### Network Layer (IP)

| Field              | Value                  | Reason |
|--------------------|------------------------|--------|
| Source IP          | `0.0.0.0`              | Client still has no IP |
| Destination IP     | `192.168.1.1`          | Now the client **knows** the router’s IP (from the Offer) |

**Key Point:**  
Unlike Discover and Offer, the Request is **not** sent as a limited broadcast (`255.255.255.255`).  
Because the client already knows the router’s IP, it can send the Request **directly** to the router.

### Data Link Layer (Ethernet)

| Field              | Value                          |
|--------------------|--------------------------------|
| Source MAC         | Client’s own MAC (e.g. `AB:CD:EF:...`) |
| Destination MAC    | Router’s MAC (learned from the Offer) |

The packet is now sent **unicast** to the router.

---

## 2. What Happens on the Router When Request Arrives

1. Router receives the frame and checks Destination MAC → it is its own MAC.
2. Network Layer → Destination IP is its own IP (`192.168.1.1`).
3. Transport Layer → Destination Port 67 → passes to DHCP Server.
4. DHCP Server reads the Request:
   - Client wants this IP
   - Client wants this Subnet Mask
   - Client wants this Default Gateway

If everything is fine, the router prepares the **DHCP Acknowledge (ACK)**.

---

## 3. DHCP Acknowledge (Router → Client)

This is the final confirmation.

### Application Layer (Router)

Router includes:

- Assigned IP Address
- Subnet Mask
- Default Gateway
- Lease time (how long the client can use this IP)

**Very Important Action by Router:**

The router updates its **DHCP Lease Table**:

```
MAC Address          →   IP Address
AB:CD:EF:...         →   192.168.1.10
```

This mapping is stored so the same IP is not given to another device.

### Transport Layer

| Field              | Value |
|--------------------|-------|
| Source Port        | **67** |
| Destination Port   | **68** |

### Network Layer

| Field              | Value                  | Reason |
|--------------------|------------------------|--------|
| Source IP          | `192.168.1.1`          | Router’s IP |
| Destination IP     | `255.255.255.255`      | Client still has **no IP configured yet** |

Even in ACK, the destination is still broadcast because the client has not applied the IP yet.

### Data Link Layer

| Field              | Value                          |
|--------------------|--------------------------------|
| Source MAC         | Router’s MAC                   |
| Destination MAC    | `FF:FF:FF:FF:FF:FF` (Broadcast) |

---

## 4. Client Receives the ACK

1. Client accepts the broadcast frame (Destination MAC = all F).
2. Checks Destination Port = 68 → accepts it.
3. Reads the ACK at Application Layer.
4. **Configures** the IP address, Subnet Mask, and Default Gateway on its NIC.
5. Now the operating system shows the real IP.

### Routing Table Update

Inside the client’s Operating System, a default route is added:

```
Destination: 0.0.0.0/0
Gateway:     192.168.1.1
```

This means:  
“For any IP that is not on my local network, send the packet to the Default Gateway (router).”

---

## 5. DORA Process is Complete

```
D → Discover
O → Offer
R → Request
A → Acknowledge
```

The client now has a real IP address and can communicate on the network.

---

## 6. Creating a Private Network (LAN)

After several devices get IPs via DHCP:

- Computer 1 → `192.168.1.10`
- Computer 2 (brother) → `192.168.1.11`
- Mother’s mobile → `192.168.1.12`
- Router LAN interface → `192.168.1.1`

All of them form a **Private Network** (also called **Local Area Network / LAN**).

### Why Private?

- The router’s WAN interface is not yet connected to the Internet.
- Devices outside this network cannot reach these IPs.
- This network is isolated like an island.

---

## 7. Network Address Calculation

Every network has a **Network Address**.

**How to find it?**

Take any IP of the network + Subnet Mask → perform **Bitwise AND** operation.

**Example:**

```
IP:          192.168.1.10
Subnet Mask: 255.255.255.0
```

In binary:

```
192.168.1.10   →  11000000.10101000.00000001.00001010
255.255.255.0  →  11111111.11111111.11111111.00000000
AND result     →  11000000.10101000.00000001.00000000
```

Convert back to decimal:

```
Network Address = 192.168.1.0
```

**Important Rule:**

- If you take **any** IP from the same subnet and AND it with the subnet mask, you always get the same Network Address.
- This is how devices know they are on the **same network**.

---

## 8. Same Network Communication

If two devices have the **same Network Address**, they are on the same LAN.

- They can communicate using only **MAC addresses**.
- No need to go through the router.
- Communication is very fast (Layer 2).

If Network Addresses are different → the packet must go through the Default Gateway (router).

---

## Visual Summary of DHCP Request Packet

```
┌─────────────────────────────────────────────────────┐
│ Ethernet Header                                     │
│  Dest MAC: Router’s MAC                             │
│  Src  MAC: Client’s MAC                             │
├─────────────────────────────────────────────────────┤
│ IP Header                                           │
│  Src IP:  0.0.0.0                                   │
│  Dest IP: 192.168.1.1 (Router)                      │
├─────────────────────────────────────────────────────┤
│ UDP Header                                          │
│  Src Port: 68                                       │
│  Dest Port: 67                                      │
├─────────────────────────────────────────────────────┤
│ DHCP Request                                        │
│  - Requested IP                                     │
│  - Subnet Mask                                      │
│  - Default Gateway                                  │
│  - Transaction ID (same as Discover/Offer)          │
└─────────────────────────────────────────────────────┘
```

---

## Visual Summary of DHCP Acknowledge Packet

```
┌─────────────────────────────────────────────────────┐
│ Ethernet Header                                     │
│  Dest MAC: FF:FF:FF:FF:FF:FF (Broadcast)            │
│  Src  MAC: Router’s MAC                             │
├─────────────────────────────────────────────────────┤
│ IP Header                                           │
│  Src IP:  192.168.1.1                               │
│  Dest IP: 255.255.255.255                           │
├─────────────────────────────────────────────────────┤
│ UDP Header                                          │
│  Src Port: 67                                       │
│  Dest Port: 68                                      │
├─────────────────────────────────────────────────────┤
│ DHCP Acknowledge                                    │
│  - Assigned IP                                      │
│  - Subnet Mask                                      │
│  - Default Gateway                                  │
│  - Lease Time                                       │
└─────────────────────────────────────────────────────┘
```

---

## Key Takeaways

- **DHCP Request** is the first unicast message (client knows the router’s IP).
- **DHCP Acknowledge** is still broadcast (client has not configured the IP yet).
- After ACK, the client configures IP, Subnet Mask, Default Gateway and updates its routing table.
- Router stores MAC ↔ IP mapping in its DHCP lease table.
- Multiple devices with the same Network Address form a **Private Network / LAN**.
- Network Address is calculated by **IP AND Subnet Mask**.
- Devices on the same Network Address can talk using only MAC addresses (very fast).

---

## What Comes Next

In the next class we will see:

- How one computer sends data/files to another computer inside the same LAN (without Internet).
- How the router is connected to the Internet (WAN side).

---

**End of Class Notes**

This document contains every important concept, field, explanation, and example taught in the video about **DHCP Request**, **DHCP Acknowledge**, Network Address calculation, and Private Network formation.
