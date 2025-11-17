message TransferParams {
    newOwner: Address;
}

struct Stats {
    attack: Int;
    defense: Int;
    speed: Int;
}

contract BeastItem {
    owner: Address;
    attack: Int;
    defense: Int;
    speed: Int;
    metadata: Cell;

    // Proper constructor – no parameters in contract header
    init(owner_: Address, attack_: Int, defense_: Int, speed_: Int, metadata_: Cell) {
        self.owner = owner_;
        self.attack = attack_;
        self.defense = defense_;
        self.speed = speed_;
        self.metadata = metadata_;
    }

    receive(msg: TransferParams) {
        require(sender() == self.owner, "Only owner can transfer");
        self.owner = msg.newOwner;
    }

    receive() {
        cashback(sender());
    }

    get fun get_owner(): Address {
        return self.owner;
    }

    get fun get_stats(): Stats {
        return Stats{
            attack: self.attack,
            defense: self.defense,
            speed: self.speed
        };
    }

    get fun get_metadata(): Cell {
        return self.metadata;
    }
}
