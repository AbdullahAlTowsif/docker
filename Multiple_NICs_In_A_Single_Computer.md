# Multiple NICs In A Single Computer

This class explains what happens when a single computer has **multiple Network Interface Cards (NICs)** and how this changes everything we have learned so far about networking.

---

## 1. Recap – Single NIC (What We Knew So Far)

Until now we assumed every computer has **only one NIC**.

### How a single NIC works:

1. Application Layer creates data
2. Presentation → Session → Transport → Network → Data Link layers process it
3. Physical Layer converts data into 0s and 1s
4. Operating System sends the binary data to the **NIC**
5. NIC converts binary into electrical (Ethernet) or electromagnetic (Wi-Fi) signals
6. NIC sends the signal to the connected device (usually the router)

**Job of the NIC:**
- Send data
- Receive data

The Operating System treats the IP received by this single NIC as **the computer’s IP**.

---

## 2. Real Life: Multiple NICs Are Possible

In real life, a computer can have **multiple Network Interface Cards**.

### Examples:

- Built-in Ethernet port
- Built-in Wi-Fi
- USB Wi-Fi adapter
- Additional Ethernet cards
- USB network adapters

A single computer can be connected to **multiple networks at the same time**.

---

## 3. What is PCI? (Peripheral Component Interconnect)

To understand multiple NICs, we must understand **PCI**.

### Full Form:
**Peripheral Component Interconnect**

### Meaning (Simple Analogy):

Imagine a road (Peripheral) that connects many houses (Components).

- **Peripheral** = Path / Road / Bus
- **Component** = Devices (CPU, RAM, Graphics Card, USB devices, NICs, etc.)
- **Interconnect** = Connection between all components

### PCI Bus:

On the motherboard there are many **PCI buses** (paths).

Each PCI bus has multiple **slots**:
- Slot 0
- Slot 1
- Slot 2
- ...

You can plug different devices into these slots:
- Graphics card
- USB devices
- Network cards (Ethernet or Wi-Fi adapters)
- Storage controllers
- etc.

**Conclusion:**  
Because of the PCI bus system, a computer can have **multiple network interfaces** plugged in at the same time.

---

## 4. Multiple NICs in Practice

### Example Scenario:

A single computer has three network interfaces:

1. **Built-in Wi-Fi** → Connected to Router A
2. **Ethernet cable** → Connected to Router B
3. **USB Wi-Fi Adapter** → Connected to Router C

### What happens?

Each NIC independently performs the **DORA process** (DHCP):

- Discover
- Offer
- Request
- Acknowledge

Result:
- NIC 1 gets IP from Router A (e.g. `192.168.1.10`)
- NIC 2 gets IP from Router B (e.g. `192.168.2.15`)
- NIC 3 gets IP from Router C (e.g. `192.168.3.20`)

**One computer now has three different IP addresses** and is connected to **three different networks** at the same time.

---

## 5. The Big Problem

When the computer wants to **send data**, a serious problem appears.

### Normal process (with single NIC):
Application → Transport → Network → Data Link → Physical → **send to the only NIC**

### With multiple NICs:
The Operating System creates the packet (with Source IP, Destination IP, Source MAC, Destination MAC), converts it to binary...

**But which NIC should it give this binary data to?**

- If it gives to NIC 1 → data goes to Network A
- If it gives to NIC 2 → data goes to Network B
- If it gives to NIC 3 → data goes to Network C

If the Destination IP belongs to Network B, but the OS sends the packet through NIC 1, the packet will never reach the destination.

This is the core problem that will be solved in the next classes.

---

## 6. Key Concepts Summary

| Concept                        | Explanation |
|--------------------------------|-----------|
| **NIC**                        | Network Interface Card – hardware that sends/receives data |
| **Multiple NICs**              | One computer can have many NICs |
| **PCI**                        | Peripheral Component Interconnect – the system that allows multiple devices to connect to the motherboard |
| **PCI Bus**                    | The actual path/line that connects components |
| **Each NIC gets its own IP**   | Through independent DHCP (DORA) process |
| **One computer = Multiple IPs**| Because each NIC can belong to a different network |
| **Problem**                    | OS must decide **which NIC** to use when sending data |

---

## 7. Important Takeaways

- A computer is **not limited** to one network interface.
- Multiple NICs mean the computer can be part of multiple networks simultaneously.
- Each NIC gets its own IP address via DHCP.
- The Operating System must intelligently choose the correct NIC when sending packets.
- Understanding this is critical for advanced networking and later for Docker networking (multiple interfaces, bridge, host, macvlan, etc.).

---

## What Comes Next

In the next classes, the instructor will explain:
- How the Operating System decides **which NIC** to use
- Routing table role in multi-NIC systems
- How source IP and outgoing interface are selected

---

**End of Class Notes**

This document contains all the core concepts taught in the video about Multiple NICs in a single computer.
