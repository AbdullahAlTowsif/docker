# Interview Questions – Docker Networking Fundamentals

**Based on Go With Habib Docker Series (Classes 037 – 050)**

This document contains **60 important Interview Questions & Answers** covering all the foundational networking topics learned so far.

---

## Section 1: IP (Internet Protocol) & Packet Structure

### 1. What is the main responsibility of the Network Layer?
**Answer:** The Network Layer is responsible for logical addressing (IP addressing) and routing packets from the source to the destination across different networks.

### 2. What are the key fields in an IPv4 header?
**Answer:**  
- Version  
- IHL (Internet Header Length)  
- Type of Service (TOS)  
- Total Length  
- Identification  
- Flags  
- Fragment Offset  
- TTL (Time To Live)  
- Protocol  
- Header Checksum  
- Source IP Address  
- Destination IP Address  

### 3. What is the purpose of the TTL field?
**Answer:** TTL prevents packets from circulating endlessly in a network. Every router decreases the TTL by 1. When TTL reaches 0, the packet is discarded.

### 4. What is the difference between a packet and a frame?
**Answer:**  
- **Packet** → Data unit at the Network Layer (contains IP header)  
- **Frame** → Data unit at the Data Link Layer (contains MAC addresses + FCS)

---

## Section 2: Data Link Layer & MAC Address

### 5. What is a MAC address?
**Answer:** MAC (Media Access Control) address is a unique 48-bit physical address permanently assigned to a Network Interface Card (NIC).

### 6. What are the main components of an Ethernet Frame?
**Answer:**  
- Preamble  
- Start Frame Delimiter (SFD)  
- Destination MAC  
- Source MAC  
- EtherType / Length  
- Payload (Data)  
- FCS (Frame Check Sequence / CRC)

### 7. What is the purpose of FCS / CRC?
**Answer:** FCS (Frame Check Sequence) is used for error detection. The receiving device recalculates the CRC and compares it with the received FCS to check if the frame was corrupted during transmission.

### 8. What is the Broadcast MAC address?
**Answer:** `FF:FF:FF:FF:FF:FF` — used when a frame needs to be delivered to every device on the local network.

---

## Section 3: First Computer, Router & IP Assignment

### 9. What is a NIC?
**Answer:** Network Interface Card — the hardware component that allows a computer to connect to a network and convert binary data into electrical or electromagnetic signals.

### 10. What is APIPA?
**Answer:** Automatic Private IP Addressing. When a computer fails to get an IP from a DHCP server, it assigns itself an IP from the range `169.254.0.0/16`.

### 11. What is the Default Gateway?
**Answer:** The IP address of the router’s LAN interface. It is the door through which a computer can communicate with devices outside its own network.

### 12. What information does a computer get from a DHCP server?
**Answer:**  
1. IP Address  
2. Subnet Mask  
3. Default Gateway  
4. DNS Server addresses (usually)

---

## Section 4: CIDR, Subnet & Subnet Mask

### 13. What is a Subnet Mask?
**Answer:** A 32-bit number that separates the Network portion from the Host portion of an IP address.

### 14. What is CIDR notation?
**Answer:** Classless Inter-Domain Routing. Example: `192.168.1.0/24` means the first 24 bits are the network portion.

### 15. How do you calculate the Network Address?
**Answer:** Perform a bitwise AND operation between the IP address and the Subnet Mask.

### 16. How many usable host IPs are there in a /24 network?
**Answer:** 2⁸ – 2 = 254 usable hosts (first address is Network, last is Broadcast).

### 17. What is the Broadcast Address?
**Answer:** The last address of a network where all host bits are set to 1. Example: In `192.168.1.0/24`, Broadcast is `192.168.1.255`.

### 18. What is the difference between /24 and /28?
**Answer:**  
- `/24` → 256 total IPs, 254 usable  
- `/28` → 16 total IPs, 14 usable

---

## Section 5: DHCP – DORA Process

### 19. What is the full form of DORA?
**Answer:** Discover → Offer → Request → Acknowledge

### 20. Why does DHCP Discover use Broadcast?
**Answer:** Because the client does not yet have an IP address and does not know the IP of the DHCP server.

### 21. What is the Source IP and Destination IP in a DHCP Discover packet?
**Answer:**  
- Source IP: `0.0.0.0`  
- Destination IP: `255.255.255.255`

### 22. What happens in the DHCP Offer stage?
**Answer:** The DHCP server offers an available IP address along with Subnet Mask, Default Gateway, and Lease Time.

### 23. Why is there a Request stage after Offer?
**Answer:** Because multiple DHCP servers may send Offers. The client chooses one and formally requests that specific IP.

### 24. What is a Lease in DHCP?
**Answer:** The duration for which the assigned IP address is valid. After the lease expires, the client must renew it.

---

## Section 6: Hub, Switch & Router

### 25. At which OSI layer does a Hub work?
**Answer:** Layer 1 (Physical Layer)

### 26. How does a Hub forward data?
**Answer:** It blindly floods the signal to all ports except the one it received the signal from.

### 27. At which layer does a Switch work?
**Answer:** Layer 2 (Data Link Layer)

### 28. What is a CAM Table?
**Answer:** Content Addressable Memory Table (also called MAC Address Table). It maps MAC addresses to the ports of the switch.

### 29. How does a Switch learn MAC addresses?
**Answer:** When a frame arrives, the Switch records the Source MAC address and the incoming port in its CAM table.

### 30. What is the difference between a Switch and a Router?
**Answer:**  
- Switch → Works with MAC addresses (Layer 2), connects devices within the same network  
- Router → Works with IP addresses (Layer 3), connects different networks

### 31. Does a modern Home Router contain only a Router?
**Answer:** No. A modern Home Router usually contains a Switch + Router + Wireless Access Point + DHCP Server inside one box.

---

## Section 7: Communication Inside the Same Network (ARP)

### 32. What is ARP?
**Answer:** Address Resolution Protocol — used to find the MAC address of a device when only its IP address is known.

### 33. What is the Destination MAC in an ARP Request?
**Answer:** `FF:FF:FF:FF:FF:FF` (Broadcast)

### 34. What is stored in the ARP Cache / ARP Table?
**Answer:** Mapping of IP Address → MAC Address

### 35. When does a computer send an ARP Request?
**Answer:** When it wants to send data to another device on the same network but does not know that device’s MAC address.

### 36. How does a Switch handle an ARP Request?
**Answer:**  
1. Learns the Source MAC  
2. Sees Destination MAC is Broadcast → Floods to all other ports

### 37. What is the difference between ARP Table and CAM Table?
**Answer:**  
- **ARP Table** → Lives on computers (IP → MAC)  
- **CAM Table** → Lives on Switches (MAC → Port)

---

## Section 8: Multiple NICs & PCI

### 38. Can a single computer have multiple NICs?
**Answer:** Yes. A computer can have multiple physical and virtual Network Interface Cards.

### 39. What is PCI?
**Answer:** Peripheral Component Interconnect — a standard that allows multiple components (including NICs) to connect to the motherboard via the PCI bus.

### 40. What happens when a computer has multiple NICs connected to different networks?
**Answer:** Each NIC gets its own IP address via DHCP. The computer becomes multi-homed (connected to multiple networks simultaneously).

### 41. What is the main problem created by multiple NICs?
**Answer:** The Operating System must decide which NIC (and which Source IP) to use when sending a packet.

---

## Section 9: Routing Table & How OS Chooses NIC

### 42. What is a Routing Table?
**Answer:** A table maintained by the Operating System that maps Destination Networks to the correct outgoing Network Interface (and next hop/gateway).

### 43. What are the most important columns in a Routing Table?
**Answer:** Destination, Gateway, Network Interface (Device), Flags, Metric

### 44. How are routes added to the Routing Table?
**Answer:** When a NIC receives an IP via DHCP, the OS calculates the Network Address (IP AND Subnet Mask) and adds a route for that network mapped to the corresponding interface. A Default Route is also added.

### 45. What is the Default Route?
**Answer:** `0.0.0.0/0` (or written as “default”). It is used when the destination IP does not match any specific network in the Routing Table.

### 46. How does the OS decide which NIC to use?
**Answer:**  
1. Takes the Destination IP  
2. Performs AND with every interface’s Subnet Mask  
3. Finds the route with the **Longest Prefix Match**  
4. If multiple matches have the same length, prefers the non-default route  
5. If nothing matches, uses the Default Route

### 47. What is Longest Prefix Match?
**Answer:** The algorithm used by the OS (and routers) to select the most specific matching route for a destination IP.

### 48. Give an example of Longest Prefix Match.
**Answer:**  
Destination: `192.168.2.10`  
- Route `192.168.2.0/24` → 24-bit match  
- Route `0.0.0.0/0` → 0-bit match  

OS chooses the `/24` route because it has the longer prefix.

### 49. What command shows the Routing Table?
**Answer:**  
- Linux: `ip route` or `route -n`  
- macOS: `netstat -rn`  
- Windows: `route print`

### 50. What is the difference between a directly connected route and a default route?
**Answer:**  
- Directly connected → Destination is on the same network as one of the NICs (Gateway is usually empty or *)  
- Default route → Used for all destinations that are not in any specific local network

---

## Section 10: Mixed / Advanced Conceptual Questions

### 51. Why does a computer need both IP and MAC addresses?
**Answer:**  
- IP is a logical address used for end-to-end delivery across networks  
- MAC is a physical address used for delivery on the local network segment

### 52. What happens if two devices have the same IP address on a network?
**Answer:** IP conflict occurs. Communication becomes unreliable or fails for both devices.

### 53. Can a Switch and a Router exist in the same physical device?
**Answer:** Yes. Almost every modern home router contains both a Layer 2 Switch and a Layer 3 Router.

### 54. Why is ARP not needed when communicating with a device on a different network?
**Answer:** Because the Destination MAC will be the MAC of the Default Gateway (Router), not the final destination. The Router will handle further delivery.

### 55. What is the role of the Physical Layer in this whole process?
**Answer:** It converts the frame (0s and 1s) into electrical signals (Ethernet) or electromagnetic signals (Wi-Fi) and transmits them over the medium.

### 56. What is a multi-homed host?
**Answer:** A computer that has multiple network interfaces and is connected to more than one network at the same time.

### 57. Why is understanding these topics important for Docker?
**Answer:** Docker creates virtual network interfaces, bridges, and routing rules. Without understanding real networking (NICs, Routing Table, ARP, etc.), Docker networking concepts (bridge, host, macvlan, overlay) become very difficult.

### 58. What is the difference between a Hub and a Switch in terms of collision domain?
**Answer:**  
- Hub → Single collision domain for all ports  
- Switch → Separate collision domain for each port

### 59. When a packet is sent to a different network, what is the Destination MAC address?
**Answer:** The MAC address of the Default Gateway (Router’s LAN interface).

### 60. Summarize the complete journey of a packet from one computer to another on the same network.
**Answer:**  
1. Application creates data  
2. Transport Layer adds ports (TCP/UDP)  
3. Network Layer adds Source & Destination IP  
4. OS checks Routing Table → selects NIC  
5. Data Link Layer needs Destination MAC → ARP is used if unknown  
6. Frame is created with Source MAC + Destination MAC  
7. Physical Layer converts to signal and sends  
8. Switches forward using CAM table  
9. Destination computer accepts the frame, processes up the layers, and replies

---

**End of Interview Questions**

This document covers **all major concepts** taught from Class 037 to Class 050.  
Revise these questions regularly — they form the foundation for Docker networking.
