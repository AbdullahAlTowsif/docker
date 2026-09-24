# DHCP Offer | Break Into Pieces | DORA Part 2

This class is **Part 2** of the DORA process.  
We break the **DHCP Offer** packet into pieces and understand exactly how the router replies to the client’s Discover request.

---

## Recap – Where We Are

1. Computer sent a **DHCP Discover** (broadcast).
2. Router received the Discover packet.
3. Now the router will reply with a **DHCP Offer**.

---

## What is DHCP Offer?

**DHCP Offer** is the second message in the DORA process.

- Sent by the **DHCP Server** (Router)
- It is the router’s proposal to the client:
  - “I can give you this IP address”
  - “This is your Subnet Mask”
  - “This is your Default Gateway”

---

## Building the DHCP Offer Packet (Layer by Layer)

The router starts from the **Application Layer** and goes down.

### 1. Application Layer (DHCP Message)

The router prepares the following important information:

| Field                        | Example Value          | Meaning |
|-----------------------------|------------------------|---------|
| **CHADDR** (Client Hardware Address) | `AB:CD:EF:...`     | The MAC address of the computer that sent the Discover |
| **Offered IP Address** (yiaddr) | `192.168.1.10`      | The IP the router is offering to the client |
| **Subnet Mask**             | `255.255.255.0`        | Default or configured subnet mask |
| **Default Gateway**         | `192.168.1.1`          | The router’s own LAN IP address |

**Important Notes:**
- The **Default Gateway** is the IP of the router’s **LAN interface**.
- If you manually configure a different subnet mask on the router, that value will be sent instead of the default `255.255.255.0`.

---

### 2. Transport Layer (UDP)

| Field              | Value     | Explanation |
|--------------------|-----------|-------------|
| **Source Port**    | **67**    | DHCP Server always uses port 67 |
| **Destination Port** | **68**  | DHCP Client always uses port 68 |

Because the original Discover came from port 68, the Offer is sent back to port 68.

---

### 3. Network Layer (IP)

| Field                  | Value                  | Explanation |
|------------------------|------------------------|-------------|
| **Source IP**          | `192.168.1.1`          | Router’s own LAN IP |
| **Destination IP**     | `255.255.255.255`      | Limited Broadcast (because the client still has no IP) |

**Why broadcast again?**  
The client still does not have an IP address configured.  
Therefore the router cannot send a unicast packet yet. It must broadcast the Offer.

---

### 4. Data Link Layer (Ethernet Frame)

| Field                  | Value                          | Explanation |
|------------------------|--------------------------------|-------------|
| **Source MAC**         | Router’s own MAC address       | e.g. `AA:BB:CC:DD:EE:FF` |
| **Destination MAC**    | `FF:FF:FF:FF:FF:FF`            | Broadcast MAC |

Even though the router knows the client’s MAC address (from CHADDR), it still uses the broadcast MAC address (`FF:FF:FF:FF:FF:FF`) because the client has not yet configured its IP.

---

## How the Packet Travels

1. Router creates the full frame (Header + Offer data).
2. Because both Destination IP and Destination MAC are broadcast values, the packet is sent to **every device** connected to the router.
3. All devices on the local network receive the frame.

---

## What Happens on Other Devices vs the Real Client

### On other devices (that did **not** send Discover):
- They receive the frame.
- They check the UDP destination port → it is **68**.
- Only the device that is currently waiting for a DHCP reply has port 68 open.
- Other devices simply **drop** the packet.

### On the real client (your computer):
1. Data Link Layer accepts the frame (broadcast MAC).
2. Network Layer accepts the packet (broadcast IP).
3. Transport Layer sees destination port **68** → accepts it.
4. Application Layer reads the DHCP Offer and checks the **CHADDR** field.
5. It sees its own MAC address → “This Offer is for me!”
6. It now knows:
   - Offered IP
   - Subnet Mask
   - Default Gateway

---

## Client’s Reaction

The client does **not** immediately configure the IP.

It first sends a **DHCP Request** (the next step of DORA) saying:

> “Yes, I accept the IP you offered me. Please assign it to me officially.”

Only after the router sends **DHCP Acknowledgement (ACK)** will the client actually use the IP.

---

## Visual Summary of DHCP Offer Packet

```
┌─────────────────────────────────────────────────────┐
│ Ethernet Header                                     │
│  Dest MAC: FF:FF:FF:FF:FF:FF                        │
│  Src  MAC: Router’s MAC                             │
├─────────────────────────────────────────────────────┤
│ IP Header                                           │
│  Src IP:  192.168.1.1 (Router)                      │
│  Dest IP: 255.255.255.255 (Broadcast)               │
├─────────────────────────────────────────────────────┤
│ UDP Header                                          │
│  Src Port: 67 (DHCP Server)                         │
│  Dest Port: 68 (DHCP Client)                        │
├─────────────────────────────────────────────────────┤
│ DHCP Offer Message                                  │
│  - CHADDR = Client’s MAC                            │
│  - Offered IP (yiaddr)                              │
│  - Subnet Mask                                      │
│  - Default Gateway                                  │
│  - Transaction ID (same as Discover)                │
└─────────────────────────────────────────────────────┘
```

---

## Key Takeaways

- DHCP Offer is sent by the **router**.
- It contains three main things the client needs: **IP**, **Subnet Mask**, and **Default Gateway**.
- Even though the router knows the client’s MAC, it still uses **broadcast** (both IP and MAC) because the client has no IP yet.
- Only the real client (the one that has port 68 open and matching CHADDR) accepts the Offer.
- After receiving the Offer, the client will send a **DHCP Request** in the next step.

---

## What Comes Next

In the next class we will break the **DHCP Request** packet into pieces.

---

**End of Class Notes**

This document captures every important detail, field, and explanation given in the video about the **DHCP Offer** packet.
