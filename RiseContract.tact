// RiseToken.tact
// Clean fungible token for $RISE
// Fully Tact-compliant & AMM-ready

message Mint {
    to: Address;
    amount: Int;
}

message Burn {
    from: Address;
    amount: Int;
}

message Transfer {
    to: Address;
    amount: Int;
}

message Approve {
    spender: Address;
    amount: Int;
}

// transferFrom → pulls tokens FROM msg.from TO caller (sender)
message TransferFrom {
    from: Address;
    amount: Int;
}

// Needed to store nested map in allowances
struct AllowanceMap {
    data: map<Address, Int>;
}

contract RiseToken {
    owner: Address;
    totalSupply: Int = 0;

    balances: map<Address, Int>;
    allowances: map<Address, AllowanceMap>;

    init(owner_: Address) {
        self.owner = owner_;
    }

    /* --------------------
       MINT & BURN (owner)
       -------------------- */

    receive(msg: Mint) {
        require(sender() == self.owner, "NOT_OWNER");

        let cur = self.balances.get(msg.to);
        let curv: Int = 0;
        if (cur != null) {
            curv = cur!!;
        }

        self.balances.set(msg.to, curv + msg.amount);
        self.totalSupply += msg.amount;
    }

    receive(msg: Burn) {
        require(sender() == self.owner, "NOT_OWNER");

        let cur = self.balances.get(msg.from);
        let curv: Int = 0;
        if (cur != null) {
            curv = cur!!;
        }

        require(curv >= msg.amount, "INSUFFICIENT_BALANCE");

        self.balances.set(msg.from, curv - msg.amount);
        self.totalSupply -= msg.amount;
    }

    /* --------------------
       TRANSFER
       -------------------- */

    receive(msg: Transfer) {
        let from = sender();

        let b = self.balances.get(from);
        let fv: Int = 0;
        if (b != null) {
            fv = b!!;
        }
        require(fv >= msg.amount, "INSUFFICIENT_BALANCE");

        // subtract from sender
        self.balances.set(from, fv - msg.amount);

        // add to recipient
        let toB = self.balances.get(msg.to);
        let tv: Int = 0;
        if (toB != null) {
            tv = toB!!;
        }

        self.balances.set(msg.to, tv + msg.amount);
    }

    /* --------------------
       APPROVE
       -------------------- */

    receive(msg: Approve) {
        let ownerAddr = sender();

        let rec = self.allowances.get(ownerAddr);
        let innerMap: map<Address, Int> = emptyMap();

        if (rec != null) {
            innerMap = rec!!.data;
        }

        innerMap.set(msg.spender, msg.amount);

        self.allowances.set(
            ownerAddr,
            AllowanceMap { data: innerMap }
        );
    }

    /* --------------------
       TRANSFER_FROM
       -------------------- */

    receive(msg: TransferFrom) {
        let caller = sender();
        let fromAddr = msg.from;

        // load allowance
        let rec = self.allowances.get(fromAddr);
        let innerMap: map<Address, Int> = emptyMap();

        if (rec != null) {
            innerMap = rec!!.data;
        }

        // get allowed amount
        let allowed = innerMap.get(caller);
        let av: Int = 0;
        if (allowed != null) {
            av = allowed!!;
        }

        require(av >= msg.amount, "INSUFFICIENT_ALLOWANCE");

        // get from-balance
        let cur = self.balances.get(fromAddr);
        let fv: Int = 0;
        if (cur != null) {
            fv = cur!!;
        }

        require(fv >= msg.amount, "INSUFFICIENT_BALANCE");

        // MOVE TOKENS:
        // subtract from `fromAddr`
        self.balances.set(fromAddr, fv - msg.amount);

        // add to caller (AMM or user)
        let toB = self.balances.get(caller);
        let tv: Int = 0;
        if (toB != null) {
            tv = toB!!;
        }

        self.balances.set(caller, tv + msg.amount);

        // decrease allowance
        innerMap.set(caller, av - msg.amount);

        self.allowances.set(
            fromAddr,
            AllowanceMap { data: innerMap }
        );
    }

    /* --------------------
       FALLBACK
       -------------------- */

    receive() {
        cashback(sender());
    }

    /* --------------------
       GETTERS
       -------------------- */

    get fun balanceOf(addr: Address): Int {
        let v = self.balances.get(addr);
        let out: Int = 0;
        if (v != null) {
            out = v!!;
        }
        return out;
    }

    get fun allowanceOf(ownerAddr: Address, spender: Address): Int {
        let rec = self.allowances.get(ownerAddr);
        if (rec == null) {
            return 0;
        }

        let m = rec!!.data;
        let v = m.get(spender);

        let out: Int = 0;
        if (v != null) {
            out = v!!;
        }

        return out;
    }

    get fun total_supply(): Int {
        return self.totalSupply;
    }
}
