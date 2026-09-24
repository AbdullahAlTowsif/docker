# CIDR | Subnet | Subnet Mask

This class is a focused revision and deeper clarification of three extremely important networking concepts that were introduced in the previous class:

1. **Subnet**
2. **Subnet Mask**
3. **CIDR Notation**

These three concepts are the foundation for understanding how IP addresses are organized, how many devices can join a network, and how broadcasting works.

---

## 1. What is a Subnet?

**Subnet** = **Sub** + **Network**

A **subnet** is a smaller network created by dividing a larger network into multiple smaller parts.

### Simple Analogy
- Bangladesh is a large country.
- It is divided into Divisions → Districts → Upazilas (sub-districts).
- Similarly, a large IP network is divided into smaller subnets.

### Why do we need Subnets?
- Better organization of devices
- Improved security (limit who can join)
- Efficient use of IP addresses
- Easier network management (e.g., one subnet per floor in a university)

---

## 2. What is a Subnet Mask?

A **Subnet Mask** is a 32-bit number that tells us:

- Which part of an IP address is the **Network portion**
- Which part is the **Host portion**

### How it works
- Bits that are **1** → Network bits (fixed)
- Bits that are **0** → Host bits (can change)

### Common Example

| IP Address       | Subnet Mask       |
|------------------|-------------------|
| `192.168.1.10`   | `255.255.255.0`   |

**Meaning:**
- First 24 bits are fixed (Network)
- Last 8 bits can change (Hosts)

**Result:**
- Network Address → `192.168.1.0`
- Broadcast Address → `192.168.1.255`
- Usable Hosts → `192.168.1.1` to `192.168.1.254` (254 devices)

---

## 3. CIDR Notation (Classless Inter-Domain Routing)

Writing the full subnet mask every time is long.  
**CIDR** is a short and modern way to write the same information.

### Format
```
IP_Address / Prefix_Length
```

**Example:**
```
192.168.1.10/24
```

- `/24` means the first **24 bits** are the network portion.
- This is exactly the same as subnet mask `255.255.255.0`.

### Common CIDR Values and Their Meaning

| CIDR   | Subnet Mask          | Total IPs | Usable Hosts | Typical Use                  |
|--------|----------------------|-----------|--------------|------------------------------|
| /32    | 255.255.255.255      | 1         | 1            | Single host                  |
| /30    | 255.255.255.252      | 4         | 2            | Point-to-point link          |
| /29    | 255.255.255.248      | 8         | 6            | Very small network           |
| /28    | 255.255.255.240      | 16        | 14           | Small office / lab           |
| /27    | 255.255.255.224      | 32        | 30           | Small department             |
| /26    | 255.255.255.192      | 64        | 62           | Medium subnet                |
| /25    | 255.255.255.128      | 128       | 126          | Larger LAN                   |
| /24    | 255.255.255.0        | 256       | 254          | Most common home/office LAN  |
| /16    | 255.255.0.0          | 65,536    | 65,534       | Large private network        |
| /8     | 255.0.0.0            | 16M+      | ~16M         | Very large network           |

---

## 4. Network Address & Broadcast Address (Reserved)

In every subnet, **two addresses are always reserved**:

1. **Network Address**  
   - The first address of the subnet  
   - All host bits are **0**  
   - Cannot be assigned to any device

2. **Broadcast Address**  
   - The last address of the subnet  
   - All host bits are **1**  
   - Used to send a message to **every device** in the subnet  
   - Cannot be assigned to any device

### Example with `/24`
```
IP + Mask:     192.168.1.10/24

Network Address:     192.168.1.0
Broadcast Address:   192.168.1.255
Usable Range:        192.168.1.1 – 192.168.1.254
```

---

## 5. How to Calculate Number of Usable Hosts

Formula:
```
Total IPs     = 2^(32 - prefix)
Usable Hosts  = Total IPs - 2
```

**Examples:**
- `/24` → 2⁸ = 256 → 254 usable
- `/28` → 2⁴ = 16 → 14 usable
- `/30` → 2² = 4 → 2 usable

---

## 6. Real-Life Use Cases (from the class)

- Home router usually uses `/24` → up to 254 devices
- If you want only 2 devices (computer + mobile), use `/30`
- University with 500 computers can create multiple `/25` or `/26` subnets (one per floor)
- Network engineers design networks by choosing the correct CIDR so that no IP is wasted and security is maintained

---

## Quick Summary Table

| Concept          | Meaning                                      | Example                     |
|------------------|----------------------------------------------|-----------------------------|
| **Subnet**       | Small network inside a large network         | Part of 192.168.0.0/16      |
| **Subnet Mask**  | Shows which bits are network vs host         | 255.255.255.0               |
| **CIDR**         | Short way to write subnet mask               | /24                         |
| **Network Addr** | First IP of the subnet (reserved)            | 192.168.1.0                 |
| **Broadcast Addr**| Last IP of the subnet (reserved)            | 192.168.1.255               |

---

## Why This Knowledge is Critical for Docker

When you create Docker networks later (`docker network create`), you will see options like:

```bash
docker network create --subnet 172.20.0.0/16 mynet
```

Understanding CIDR and Subnet Mask is mandatory to properly design and troubleshoot Docker bridge, overlay, and custom networks.

---

**End of Class Notes**

This document contains every core concept, formula, example, and practical point taught in the video about **CIDR, Subnet, and Subnet Mask**.
