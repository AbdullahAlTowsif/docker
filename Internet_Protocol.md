# Internet Protocol - IP

## Introduction & Importance

This class focuses on the **Internet Protocol (IP)**, which operates at the **Network Layer (Layer 3 / L3)** of the OSI model.

- After completing this class and the next one (Data Link Layer / L2), you will have a solid foundation for understanding networking.
- Without properly understanding these two layers (Network Layer + Data Link Layer), true understanding of networking is impossible. People who claim to know networking without this foundation are usually just memorizing patterns.
- The Network Layer is the foundation of the entire world of networking.
- Previous classes on the OSI model and TCP/IP model must be thoroughly understood first.

### Real-world Analogy
Imagine sending a message (“I love you”) from your mobile/computer in one country (e.g., Bangladesh) to someone in another country (e.g., America). The message travels through multiple routers across continents and oceans. Understanding **how** the message reaches the correct destination, what happens along the way, and how routers handle it is the core of networking.

---

## Encapsulation Recap (Layers)

| Layer              | Unit Name   | What is added                          |
|--------------------|-------------|----------------------------------------|
| Transport Layer (L4) | Segment    | Source Port + Destination Port (+ TCP/UDP header) |
| Network Layer (L3)   | Packet     | Source IP + Destination IP (+ IP header) |
| Data Link Layer (L2) | Frame      | Source MAC + Destination MAC (+ Frame header) |

- In the **Transport Layer**, data becomes a **Segment** (TCP or UDP).
- When it reaches the **Network Layer**, the segment becomes the **payload/data** of an **IP Packet**. An IP header is added in front.
- At the **Data Link Layer**, the entire IP packet becomes the payload of a **Frame**, and MAC addresses are added.

---

## IP Packet Structure (IPv4)

An IP packet consists of a **Header** + **Data (Payload)**.

- The entire packet is made of binary data (0s and 1s).
- Minimum header size: **20 bytes**.
- Maximum header size (with options): **60 bytes**.
- Options field: up to **40 bytes** (rarely used today; reserved for future use). Larger headers make packets heavier and slower to process across routers.

### Field-by-Field Breakdown

#### 1. Version (4 bits)
- Indicates whether the packet is **IPv4** or **IPv6**.
- Binary value `0100` (decimal 4) → IPv4
- Binary value `0110` (decimal 6) → IPv6
- Routers check this first to know how to process the packet.

#### 2. IHL – Internet Header Length (4 bits)
- Tells the router the length of the IP header.
- Value is in units of **4 bytes** (32-bit words).
  - Minimum value = 5 → 5 × 4 = **20 bytes** (no options)
  - Maximum value = 15 → 15 × 4 = **60 bytes** (with options)
- The router uses this to know exactly where the header ends and the data (payload) begins.
- Example:
  - IHL = 5 → First 20 bytes = header, rest = data
  - IHL = 15 → First 60 bytes = header, rest = data

#### 3. TOS / DSCP + ECN (8 bits) – Originally called Type of Service
- Older name: **TOS (Type of Service)** – rarely used in that form now.
- Modern interpretation:
  - First **6 bits** → **DSCP (Differentiated Services Code Point)**
  - Last **2 bits** → **ECN (Explicit Congestion Notification)**

**DSCP (Priority / QoS):**
- Allows routers to prioritize certain traffic.
- Analogy: On a congested road, ambulances (high priority) get preference over regular cars or trucks.
- Examples of priority:
  - Voice calls (WhatsApp, etc.) → Highest priority (must arrive immediately)
  - Web browsing / Facebook → Medium/Low priority
  - Large file downloads (10 GB) → Lowest priority (delay is acceptable)
- Routers examine these 6 bits to decide how urgently to forward the packet.

**ECN (Congestion Control):**
- Used when a router is overloaded with traffic.
- The router can signal the sender: “Slow down, I am congested.”
- Better to slow down than to drop packets completely (which could cause the router to crash or overheat).

#### 4. Total Length (16 bits)
- Total size of the entire IP packet = **Header + Data**.
- Maximum possible value: **65,535 bytes** (2¹⁶ − 1).
- Combined with IHL, the router can precisely calculate:
  - Header size
  - Data (payload) size and location

#### 5. Identification (16 bits)
- Used when a large packet must be **fragmented** into smaller packets.
- All fragments of the same original packet share the **same Identification number**.
- Maximum value: 65,535.
- Helps the receiving router reassemble the correct fragments together.

#### 6. Flags (3 bits)
Three flags exist:

| Flag | Name              | Meaning |
|------|-------------------|---------|
| Bit 1 | **Reserved**     | Currently unused (reserved for future use) |
| Bit 2 | **DF – Don’t Fragment** | If set to 1 → Router must **not** fragment this packet. If the packet is too large for the next link, it is dropped. |
| Bit 3 | **MF – More Fragments** | If set to 1 → More fragments of this packet are coming. If 0 → This is the last fragment. |

**Fragmentation Analogy:**
- A large truck cannot pass through a narrow road.
- The cargo is loaded onto several smaller trucks (fragments).
- At the destination, the cargo is reassembled into the original large shipment.

#### 7. Fragment Offset (13 bits)
- Indicates the position of this fragment within the original packet.
- Allows the receiving router to put the fragments back in the correct order, even if they arrive out of order.
- Without Fragment Offset, the receiver would not know the correct sequence.

#### 8. TTL – Time To Live (8 bits)
- Extremely important field.
- Typical starting values: **64** or **128**.
- Every time a router forwards the packet, it **decrements TTL by 1**.
- When TTL reaches **0**, the packet is **discarded** (not forwarded further).
- Purpose: Prevents packets from looping forever in the network (routing loops).
- Question raised in class: How can a packet travel from Bangladesh to America with only 64 hops?  
  → Answer involves sophisticated routing algorithms (to be covered in future advanced classes). In practice, the number of hops required is usually far fewer than 64.

#### 9. Protocol (8 bits)
- Indicates which **Transport Layer protocol** is inside the payload.
- Common values:
  - TCP
  - UDP
  - Other protocols (ICMP, etc.)
- When the packet reaches the destination Network Layer, this field tells it to hand the payload to the correct upper-layer protocol (TCP or UDP).

#### 10. Header Checksum (16 bits)
- Error-detection mechanism for the **IP header only** (not the data).
- Calculation (simplified):
  1. Treat the header as a series of 16-bit words.
  2. Add them all together in binary.
  3. Take the **one’s complement** of the sum.
  4. Store the result in the Checksum field.
- At the receiver:
  - The same calculation is performed (including the received checksum).
  - If the result is all 1s (or equivalent correct value), the header is considered intact.
  - Otherwise, the packet is considered corrupted and is discarded.
- Note: The instructor mentioned he has explained checksum multiple times in previous classes.

#### 11. Source IP Address (32 bits)
- The IP address of the **sender**.
- 32 bits → four 8-bit octets → range of each octet: **0–255**.
- Written in dotted-decimal notation, e.g., `192.168.10.3`.
- This is why IPv4 addresses look the way they do.

#### 12. Destination IP Address (32 bits)
- The IP address of the **intended receiver**.
- Same format as Source IP Address (32 bits / 4 octets).

#### 13. Options (0–40 bytes) + Padding
- Optional field.
- Rarely used in modern networks.
- Reserved for future extensions.
- Increases header size and processing overhead → generally avoided.

#### 14. Data / Payload
- Contains the entire **Transport Layer Segment** (TCP header + TCP data, or UDP header + UDP data).
- From the Network Layer’s perspective, this is just “data”.
- From the Transport Layer’s perspective, it still has its own header + application data.

---

## Role of Routers (L3 Devices)

- A **router** is an **L3 device** because it can:
  - Read and understand the IP header.
  - Examine Version, IHL, DSCP/ECN, Total Length, Identification, Flags, Fragment Offset, TTL, Protocol, Checksum, Source IP, Destination IP.
  - Modify certain fields (especially decrement TTL, and handle fragmentation if needed).
  - Forward the packet toward the correct next hop based on the Destination IP.

### Device Classification by Layer Visibility
| Device Type          | Can Read Headers Up To |
|----------------------|------------------------|
| Switch               | L2 (Data Link Layer – MAC addresses) |
| Router               | L3 (Network Layer – IP addresses) |
| L4 Load Balancer     | L4 (Transport Layer – Ports, TCP/UDP) |
| L7 Load Balancer     | L7 (Application Layer – actual data/content) |

- **L2 Load Balancer**: Only sees MAC addresses.
- **L3 Load Balancer / Router**: Sees IP headers.
- **L4 Load Balancer**: Sees IP + TCP/UDP headers.
- **L7 Load Balancer**: Can inspect application-level data.

---

## Key Takeaways & Why This Matters

1. Every time you send even a single character of data, multiple headers are added at different layers (TCP/UDP → IP → Frame). This overhead affects latency and throughput.
2. Understanding the IP header is essential before studying the Data Link Layer (next class).
3. Many advanced networking concepts (routing algorithms, QoS, congestion control, load balancing, fragmentation, etc.) build directly on these fields.
4. The instructor emphasizes that this is foundational knowledge for both Docker networking and future advanced courses (including Go-related networking topics).
5. Memorization is not enough — true understanding of how packets travel, how routers make decisions, and why each field exists is required.

---

## Closing Remarks from the Instructor

- This class + the upcoming Data Link Layer class form the essential base for networking.
- Continue the course series to understand the “magic” of how packets efficiently travel the world with limited TTL values and intelligent routing.
- Best of luck. May Allah protect everyone.

---

**Note:** This document captures all major technical explanations, analogies, field definitions, bit sizes, and conceptual points presented in the video. Minor conversational or motivational remarks have been summarized for clarity while preserving complete technical accuracy.
