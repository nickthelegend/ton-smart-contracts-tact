import "@stdlib/nft";

contract BeastItem with NftItem {
    var attack: Int = 0;
    var defense: Int = 0;
    var speed: Int = 0;

    init(content: Cell, attack: Int, defense: Int, speed: Int) {
        self.content = content;
        self.attack = attack;
        self.defense = defense;
        self.speed = speed;
    }

    get fun get_stats(): (Int, Int, Int) {
        return (self.attack, self.defense, self.speed);
    }
}
