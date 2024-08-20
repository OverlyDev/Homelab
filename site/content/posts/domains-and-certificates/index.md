---
title: "Domains and Certificates"
date: "2024-08-19T01:55:08Z"
draft: false
cover:
    image: "pexels-photo-196655.jpeg"
    alt: "Person Using Laptop Computer during Daytime"
    caption: "I didn't have a good picture for this, thanks [Pexels](https://www.pexels.com/)!"
ShowToc: true
TocOpen: true
---

This page will be a high-level overview of domains and certificates since they can be an important aspect of one's homelab.

## Domains

Everyone interacting with the internet deals with these. Domains represent a "name", a domain name if you will, that can be associated with one or more IP addresses. These associations are created via DNS (Domain Name Service) records which are public information. This allows a user to navigate to `github.com` and be presented with the destination page without having to remember any pesky IP addresses.

### TLDs

There's a *ton* of domains out there so, in order to manage them efficiently, there's entities that govern each TLD (Top-Level Domain). TLDs are everything after the final `.` of a URL, for example: `com`, `org`, `us`, `dev`, etc.

Those in charge of each TLD can dictate rules that must be followed in order to keep a domain with them. Some examples:

- `.dev` is only served over HTTPS
  - Technically this is accomplished via HSTS preload but nonetheless can cause headaches
- `.us` requires the registrant to be a valid US citizen
  - Also doesn't allow WHOIS privacy protections which we'll talk about later

### Registration

Individuals or businesses looking to register a domain name typically work with a registrar, which is essentially just a broker and manager for various TLDs. There's a lot of different registrars out there but I appreciate [Cloudflare](https://www.cloudflare.com/products/registrar/) since they have very competitive pricing and make management really easy.

I won't break down the entire registration process but will highlight a couple important notes for you to consider:

#### WHOIS Privacy

Since domain registration is public domain information, it can be scary having your personal information tied to a domain. A registrar providing WHOIS privacy alleviates this concern by providing generic information for the domain registration. It boils down to "Contact the registrar" and removes an individuals personal information from the equation.

However! Not every domain allows this, as mentioned with the `.us` TLD above. If this is important to you, ensure you read what the registrar provides for your chosen domain, as well as maybe Googling the domain to verify it's allowed.

#### Appearance

The most sought after TLD is `.com` since its ubiquitous with the internet. Chances are, the really cool domain you thought of will already have been taken on `.com` and so the search begins on the myriad of TLDs to find somewhere it's available.

One thing to keep in mind is not all TLDs carry the same "prestige", for lack of better words. This may not be an issue if you're the only one messing around with your domain. However, including other people/users becomes difficult if you're sending a link to `cooltech.tk`; it just *feels wrong*.

But it's not just my feelings here, [there's some data to back it up](https://www.cybercrimeinfocenter.org/top-20-tlds-by-malicious-phishing-domains).

Another fun aspect to consider is trying to access your services from behind any sort of corporate proxy or otherwise. Chances are, domains not in the top-25 are straight up blocked.

The tl;dr here is to consider your choice of TLD from multiple angles, weigh your risks/tolerations, and make a good choice.

### DNS

Once you've gotten your hands on a shiny new domain, the next step would be to populate some DNS records. These equate to saying "Hey if you're trying to reach `myhomelab.com`, talk to IP address: `x.x.x.x`"

A way to test this out and understand the process:
1. Spin up a VPS somewhere
1. Throw [this](https://gist.github.com/chrisvfritz/bc010e6ed25b802da7eb) into an `index.html` file
1. Start up a simple file server on port 80 via: `python3 -m http.server 80`
    - Note this may require `sudo` since the port is < 1024
1. Ensure the VPS' firewall rules allows port 80 ingress
1. Snag the public IP address for your VPS
1. Create a DNS entry for `hello.<yourdomain>` pointing to the VPS' public IP
1. Navigate to `hello.<yourdomain>` and voila!
    - It may take a few minutes for DNS records to propogate

## Certificates

An important topic to be sure, TLS certificates ensure the authenticity and security of websites and services interacted with via HTTPS. I won't begin to try to explain the TLS handshake, how encryption works, or any of the other nitty gritty details as there's already a ton of great information out there on the subject.

As always, I'll approach this topic from a homelab perspective and explain how it ties in.

### The Why

For some homelab environments, everything is self-contained meaning services are accessed from within the same network. In this case, it's more of a personal security choice to implement TLS. Best practice, probably, but for the potential headaches some may not deem it worth the investment.

Things change once services are accessible from outside your network. In my mind, anything crossing over the internet should be secured, from a privacy as well as a security standpoint.

<!-- Uncomment below once the secure-access post is finished -->

<!-- ### The How

There's various methods to secure services as well as specific configuration required per-service. Due to this, it's hard to provide a one-size-fits-all guide. I recommend reading the [Secure Access]( {{< ref "posts/secure-access" >}} ) post to get some ideas that may fit your requirements. -->
