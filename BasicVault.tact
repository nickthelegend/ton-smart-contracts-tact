// BasicVault — contract parameters in header (no init())
message Deposit {
    amount: Int as coins;
}

message Withdraw {
    amount: Int as coins;
}

contract BasicVault(
    owner: Address,
    balance: Int as coins
) {

    // Anyone can send a Deposit message
    receive(msg: Deposit) {
        self.balance += msg.amount;
        cashback(sender());
    }

    // Only owner can withdraw
    receive(msg: Withdraw) {
    require(sender() == self.owner, "NOT_OWNER");
    require(self.balance >= msg.amount, "INSUFFICIENT_FUNDS");

    self.balance -= msg.amount;

    send(SendParameters {
        to: self.owner,
        value: msg.amount,
        mode: SendRemainingValue | SendIgnoreErrors,
    });

    cashback(sender());
}


    // Fallback — handle raw TON transfers
    receive() {
        self.balance += context().value;
        cashback(sender());
    }

    // Getter for balance
    get fun getBalance(): Int {
        return self.balance;
    }

    // Getter for owner
    get fun getOwner(): Address {
        return self.owner;
    }
}
