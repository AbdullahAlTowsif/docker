# Data Link Layer Frame

## Introduction

This class provides a **rough wrap-up / overview** of the **Data Link Layer Frame**.

- The class is intentionally kept **abstract** because the topic is very complicated.
- There are many different frame formats depending on the underlying technology (Ethernet, Wi-Fi, etc.).
- It is not practical (or necessary at this stage) to memorize every version of every protocol.
- The goal is to understand the **common structure** and the role of the Data Link Layer (Layer 2 / L2).

---

## Overall Encapsulation Flow (Reminder)

When an application wants to send data (example: the text `"I love you"`):

1. **Application Layer (L7)**  
   Sends the data (e.g., plain text, JSON, XML, image, etc.).

2. **Presentation Layer (L6)**  
   Converts the data into a proper format (e.g., JSON binary representation).

3. **Session Layer (L5)**  
   Usually skipped / not heavily used in this context.

4. **Transport Layer (L4)**  
   - Adds **TCP header** (or UDP header).  
   - Large data is broken into multiple **segments**.  
   - Example: 10 MB of data → 10 separate 1 MB TCP segments.  
   - Each segment contains: Source Port, Destination Port, Sequence Number, Acknowledgement Number, Flags, Window Size, Checksum, Urgent Pointer + Data.

5. **Network Layer (L3)**  
   - Each TCP/UDP segment becomes the **payload** of an **IP Packet**.  
   - IP header is added in front (Version, IHL, TOS/DSCP/ECN, Total Length, Identification, Flags, Fragment Offset, TTL, Protocol, Checksum, Source IP, Destination IP, Options).  
   - Result: Multiple IP packets (one for each segment).

6. **Data Link Layer (L2)**  
   - Takes each IP packet and wraps it with a **Header** in front and a **Trailer** at the end.  
   - The combination **Header + IP Packet + Trailer** is called a **Frame**.  
   - This Frame is passed to the Physical Layer.

7. **Physical Layer (L1)**  
   - Converts the Frame into actual signals (electrical signals on Ethernet cable, radio waves for Wi-Fi, etc.).  
   - Only 0s and 1s travel on the wire or through the air.

---

## Structure of a Data Link Layer Frame

A typical Frame looks like this:

```
[ Header ] + [ Network Layer Packet (IP Packet) ] + [ Trailer ]
```

- The exact fields inside the Header and Trailer depend on the protocol being used (Ethernet, Wi-Fi 802.11, etc.).
- Different protocols have different frame formats and different maximum sizes.

### Common / Important Fields (Especially in Ethernet)

#### Header Fields (most common ones)

| Field                  | Size          | Description |
|------------------------|---------------|-------------|
| **Preamble**           | Variable     | Synchronization pattern (helps the receiver detect the start of the frame) |
| **SFD (Start Frame Delimiter)** | -        | Marks the actual beginning of the frame |
| **Destination MAC Address** | 6 bytes (48 bits) | Physical address of the receiving device |
| **Source MAC Address**     | 6 bytes (48 bits) | Physical address of the sending device |
| **EtherType / Length**     | 2 bytes      | Indicates either the type of the upper-layer protocol (e.g., IPv4, IPv6, ARP) **or** the length of the data |

#### Data / Payload
- Contains the **entire Network Layer Packet** (IP Packet).
- Size limits (important):
  - **Ethernet**: Data size typically **46–1500 bytes** (Maximum Transmission Unit / MTU is usually 1500 bytes).
  - **Wi-Fi**: Can support larger sizes in some versions (e.g., up to ~2312 bytes in certain cases).

#### Trailer
| Field                  | Size          | Description |
|------------------------|---------------|-------------|
| **FCS (Frame Check Sequence)** or **CRC** | Usually 4 bytes (32 bits) | Error detection code |

---

## MAC Address (Very Important)

- **MAC Address** = Media Access Control Address = **Physical Address** of a network interface.
- Size: **6 bytes (48 bits)**.
- Written in hexadecimal, e.g., `10:20:30:10:15:06`.
- Every network device has a unique MAC address:
  - Computer
  - Mobile phone
  - Router
  - Smart devices
  - Network Interface Card (NIC)
- Assigned by the manufacturer when the hardware is made.
- Used for **direct communication** between devices on the **same local network** (same broadcast domain).

### How Devices Use MAC Addresses

Example scenario:
- Computer ↔ Router ↔ Mobile phone (all connected on the same local network)

1. When the computer connects to the router, it learns and stores the router’s MAC address.
2. When the computer wants to send data to the router, it puts:
   - **Source MAC** = Computer’s own MAC
   - **Destination MAC** = Router’s MAC
3. The router can then forward the frame to the mobile phone using the mobile’s MAC address.

Because MAC addresses are physical and local, devices on the same link can communicate directly using them.

---

## Why Frame Size is Limited (e.g., 1500 bytes on Ethernet)

- In the previous class we learned that an IP packet can be up to **65,535 bytes**.
- But an Ethernet frame’s data portion is limited to ~**1500 bytes**.

**Why the mismatch?**
- If the IP packet is larger than the frame’s maximum data size, the **Network Layer (router)** performs **fragmentation**.
- The large IP packet is broken into multiple smaller packets.
- Each smaller packet is put into its own Frame.
- Fragment Offset and Identification fields (from the IP header) are used so the receiver can reassemble the original packet.

**Why not make frames larger?**
- Hardware limitations.
- Smaller frames are easier to handle.
- If an error occurs, only a small amount of data needs to be retransmitted.
- Different protocols choose different maximum sizes based on their design trade-offs (Ethernet ~1500, some Wi-Fi versions larger).

---

## FCS / CRC – Error Detection

- **CRC** = Cyclic Redundancy Check (an algorithm).
- **FCS** = Frame Check Sequence (the actual value stored in the trailer).

### How it works:

1. **Sender side**:
   - Takes the entire Header + Data.
   - Runs it through the CRC algorithm.
   - Produces a fixed-size result (usually 32 bits).
   - Places this result in the **FCS** field of the Trailer.
   - Sends the complete Frame.

2. **Receiver side**:
   - Takes the received Header + Data.
   - Runs the same CRC algorithm again.
   - Compares the newly calculated value with the received FCS.
   - **If they match** → Frame is considered correct → Pass the IP Packet up to the Network Layer.
   - **If they do not match** → Frame is corrupted → **Drop the frame** (do not request retransmission at L2).

**Important point**:
- The Data Link Layer only **detects** errors and drops bad frames.
- It does **not** request retransmission itself.
- Retransmission is the responsibility of higher layers (mainly **TCP**).
- If TCP notices that a segment is missing, it will request the sender to retransmit that segment.

---

## What Happens After the Frame is Received Correctly

1. Data Link Layer removes the Header and Trailer.
2. Passes the pure **IP Packet** up to the Network Layer (L3).
3. Network Layer removes the IP header and passes the **Segment** up to the Transport Layer (L4).
4. Transport Layer (TCP/UDP) removes its header and passes the pure data up.
5. Session → Presentation → Application layers process the data.
6. Finally the application receives the original data (e.g., the JSON `"I love you"`).

---

## Protocol Variations

- **Ethernet** and **Wi-Fi** have different frame formats.
- Wi-Fi itself has many versions: 802.11a, 802.11b, 802.11g, 802.11n, 802.11ac, 802.11ax, etc.
- Ethernet also has multiple variants.
- It is impossible (and unnecessary) to learn every single format in one class.
- What is **common** across almost all of them:
  - Source MAC Address
  - Destination MAC Address
  - Data (the Network Layer packet)
  - Some form of error-checking trailer (FCS/CRC)

When you work with advanced networking later, you will study the specific format you need.

---

## Why This Knowledge Matters for Docker

The instructor emphasizes:

- Docker has its own networking (bridge networks, host networks, overlay networks, IP tables, etc.).
- Without a solid understanding of basic networking (IP + Frames + MAC addresses + routing concepts), it is very difficult to understand Docker networking deeply.
- This class + the previous IP class complete the foundational networking knowledge needed before going deeper into Docker networking topics.

---

## What Comes Next

From the next class onward, the instructor will cover more practical and interesting networking topics such as:

- Gateway
- Subnet Mask
- CIDR Notation
- How IP addresses actually work
- Routing Tables
- ARP (Address Resolution Protocol)
- LAN / WAN concepts
- And then connect everything to Docker networking (bridge, host, overlay, etc.)

---

## Closing Remarks

- This class was kept abstract on purpose because Data Link Layer protocols are numerous and complex.
- Focus on the **common concepts**: Frame structure, MAC addresses, FCS/CRC, and the relationship with IP packets.
- The foundations (OS + Networking) are almost complete. After this, deeper Docker topics will become much clearer.
- Best of luck. May Allah protect everyone.

---

**Note:** This document captures all the technical explanations, analogies, size limits, error-handling behavior, and conceptual points presented in the video while preserving the instructor’s teaching style and emphasis.
