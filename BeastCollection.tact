import "@stdlib/nft";

contract BeastCollection with NftCollection {

    // Only oracle can mint (not user)
    const oracle: Address;

    init(owner: Address, oracle: Address) {
        self.owner = owner;
        self.oracle = oracle;
    }

    // Oracle mints random beast
    receive("mint_random_beast", to: Address, attack: Int, defense: Int, speed: Int, content: Cell) {
        require(sender() == self.oracle, "Only oracle can mint beasts");
        self._mint_with_init(to, content, init: { attack: attack, defense: defense, speed: speed });
    }
}
