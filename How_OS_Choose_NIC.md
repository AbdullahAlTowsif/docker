# How OS choose NIC

This class **corrects and clarifies** a concept from the previous class (Routing Table).  
It explains in detail **exactly how the Operating System decides which NIC** to use when a computer has multiple network interfaces.

---

## 1. Background & Correction

In the previous class, the explanation of how the OS selects the correct NIC was incomplete.  
This class re-explains the same concept properly using **Longest Prefix Match**.

### Scenario Recap

A computer is connected to three different networks via three NICs:

| NIC Name       | Network Address     | Computer’s IP on that NIC | Subnet Mask     |
|----------------|---------------------|---------------------------|-----------------|
| **en0** (primary) | `192.168.1.0/24`   | `192.168.1.23`           | `255.255.255.0` |
| **en1**           | `10.10.1.0/24`     | `10.10.1.23`             | `255.255.255.0` |
| **en2** (Wi-Fi)   | `192.168.2.0/24`   | `192.168.2.4`            | `255.255.255.0` |

**Routing Table (simplified):**

```
Destination          Interface
--------------------------------
192.168.1.0/24       en0
10.10.1.0/24         en1
192.168.2.0/24       en2
0.0.0.0/0            en0          ← Default Route
```

---

## 2. Core Question

When the computer wants to send data to a destination IP (for example `192.168.2.2`),  
**how does the Operating System decide which NIC to use?**

---

## 3. The Correct Algorithm (How OS Chooses NIC)

The Operating System does the following:

1. Takes the **Destination IP**.
2. Performs a **bitwise AND** operation with the **Subnet Mask (Netmask)** of **every** interface.
3. Compares the resulting Network Address with the Destination entries in the Routing Table.
4. Selects the route that has the **longest matching prefix** (most matching bits).
5. If two routes match equally, the **non-default** route gets higher priority.
6. If no specific route matches, the **Default Route** (`0.0.0.0/0`) is used.

---

## 4. Detailed Example

**Destination IP:** `192.168.2.2`

### Step-by-step calculation:

**With en0’s Subnet Mask (`255.255.255.0`):**
```
192.168.2.2  AND  255.255.255.0  =  192.168.2.0
```
Matches the route `192.168.2.0/24`? → **Yes** (24 bits match)

**With en1’s Subnet Mask (`255.255.255.0`):**
```
192.168.2.2  AND  255.255.255.0  =  192.168.2.0
```
Does **not** match `10.10.1.0/24`

**With en2’s Subnet Mask (`255.255.255.0`):**
```
192.168.2.2  AND  255.255.255.0  =  192.168.2.0
```
Matches `192.168.2.0/24` perfectly (24 bits)

**With Default Route (`0.0.0.0/0`):**
```
Always matches (0 bits specific match)
```

### Decision:

- `192.168.2.0/24` (via en2) → 24-bit match
- Default route → 0-bit match

**Result:** The OS chooses **en2** because it has the **longest prefix match**.

Source IP becomes the IP of en2 (`192.168.2.4`).

---

## 5. Priority Rules Summary

| Situation                                      | What OS Does |
|------------------------------------------------|--------------|
| One route has more matching bits than others   | Choose the one with **longest prefix** |
| Multiple routes have the same length match     | Prefer the **non-default** route |
| No specific route matches                      | Use the **Default Route** (`0.0.0.0/0`) |

---

## 6. Full Packet Flow After NIC Selection

Once the NIC is chosen:

1. **Network Layer**
   - Source IP = IP of the selected NIC
   - Destination IP = the target IP

2. **Data Link Layer**
   - Source MAC = MAC of the selected NIC
   - Destination MAC = Resolved via ARP (either the target host or the Default Gateway)

3. **Physical Layer**
   - Binary data is converted to electrical / electromagnetic signals

4. Operating System sends the frame to the **selected NIC**.

---

## 7. Key Concepts Clarified

- **Subnet Mask** and **Netmask** are the same thing.
- The OS does **not** randomly pick a NIC.
- Selection is based on **Longest Prefix Match**.
- Default route is only used when no better (more specific) match exists.
- This is the fundamental mechanism that allows multi-homed computers to work correctly.

---

## 8. Important Takeaways

- The Routing Table + Longest Prefix Match is how the OS decides the outgoing interface.
- More specific routes always win over the default route.
- Understanding this is essential for:
  - Multi-NIC servers
  - Docker networking
  - Advanced routing concepts

---

## What Comes Next

- Loopback Interface (`127.0.0.1`)
- External communication
- Docker Bridge Networking

---

**End of Class Notes**

This document contains the corrected and complete explanation of how the Operating System chooses the correct NIC using the Routing Table and Longest Prefix Match algorithm.
