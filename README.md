# TON Smart Contracts (Tact)

![Tact](https://img.shields.io/badge/Tact-1.6-blue?style=flat-square) ![TON](https://img.shields.io/badge/TON-blockchain-0098EA?style=flat-square)

> A small collection of smart contracts for the TON blockchain, written in [Tact](https://tact-lang.org) — a vault, a fungible token, and an on-chain NFT collection.

## Overview

This repository is a hands-on set of TON smart contracts implemented in the Tact language. Each contract is self-contained and demonstrates a common on-chain primitive: holding funds, issuing a fungible token, and minting NFTs with on-chain stats. It's intended as a practical reference and playground for building on TON with Tact and the `@tact-lang/compiler` toolchain.

## Features

- **BasicVault** — a minimal deposit/withdraw vault. Anyone can deposit, only the owner can withdraw, with `INSUFFICIENT_FUNDS` and owner checks. Exposes `getBalance` and `getOwner` getters and handles raw TON transfers via a fallback receiver.
- **RiseToken (`$RISE`)** — a fungible token with an ERC-20-style interface: owner-gated `Mint`/`Burn`, `Transfer`, and an `Approve` / `TransferFrom` allowance flow (nested allowance maps) designed to be AMM-friendly. Getters for `balanceOf`, `allowanceOf`, and `total_supply`.
- **BeastCollection** — an NFT collection contract that acts as a factory: on an owner-only `MintParams` message it computes the child address, records the index, and deploys a `BeastItem` child contract with on-chain stats and metadata.
- **BeastItem** — the individual NFT contract storing `attack` / `defense` / `speed` stats plus a metadata cell, with owner-only transfer and stat/metadata getters.

## Tech Stack

- **[Tact](https://tact-lang.org)** — smart contract language for TON (`@tact-lang/compiler` ^1.6.13)
- **TON** — `ton` ^13.9.0, `ton-core` ^0.53.0, `@ton/crypto` ^3.3.0
- **pnpm** — package manager (`pnpm@10.22.0`)

## Getting Started

```bash
# clone
git clone https://github.com/nickthelegend/ton-smart-contracts-tact.git
cd ton-smart-contracts-tact

# install dependencies
pnpm install

# compile the contracts defined in tact.config.json (BeastItem, BeastCollection)
pnpm tact --config tact.config.json
```

Compiled artifacts are written to `./build`. To compile a single contract directly, you can also run `pnpm tact <File>.tact`.

## Project Structure

```
BasicVault.tact        # deposit / owner-only withdraw vault
RiseContract.tact      # RiseToken ($RISE) fungible token with allowances
BeastCollection.tact   # NFT collection / factory that deploys BeastItem children
BeastItem.tact         # NFT item with on-chain stats + metadata
tact.config.json       # Tact build config (BeastItem, BeastCollection)
package.json           # dependencies
```

---

Built by [**nickthelegend**](https://github.com/nickthelegend) · [nickthelegend.tech](https://nickthelegend.tech)
