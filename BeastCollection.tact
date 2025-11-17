message MintParams {
    to: Address;
    attack: Int;
    defense: Int;
    speed: Int;
    metadata: Cell;
}

struct BeastInfo {
    item: Address;
}

contract BeastCollection {
    owner: Address;
    itemCode: Cell;
    nextIndex: Int = 0;
    beasts: map<Int, Address>;

    init(owner_: Address, itemCode_: Cell) {
        self.owner = owner_;
        self.itemCode = itemCode_;
    }

    receive(msg: MintParams) {
        require(sender() == self.owner, "Only owner can mint");

        let idx = self.nextIndex;
        self.nextIndex += 1;

        // Build DATA cell for BeastItem.init(...)
        let data = beginCell()
            .storeAddress(msg.to)
            .storeInt(msg.attack, 32)
            .storeInt(msg.defense, 32)
            .storeInt(msg.speed, 32)
            .storeRef(msg.metadata)
            .endCell();

        // FIXED: Proper typed StateInit
        let stateInit = StateInit {
            code: self.itemCode,
            data: data
        };

        // compute address (now works)
        let itemAddr = contractAddress(stateInit);

        // store index → address
        self.beasts.set(idx, itemAddr);

        // deploy child BeastItem
        deploy(DeployParameters {
            init: stateInit,
            value: ton("0.05")
        });
    }

    receive() {
        cashback(sender());
    }

    get fun total_minted(): Int {
        return self.nextIndex;
    }

    get fun get_beast(idx: Int): BeastInfo? {
        let a = self.beasts.get(idx);
        if (a == null) { return null; }
        return BeastInfo { item: a!! };
    }
}
