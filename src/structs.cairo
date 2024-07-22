pub struct Summary {
    minimumContribution: usize,
    balance: usize,
    numberOfRequests: u16,
    numberOfApprovers: u16,
    managerAddress: ByteArray
}

pub struct Request {
    description: ByteArray,
    value: usize,
    recipient: ByteArray,
    isComplete: bool,
    yesVotes: usize,
    voters: Felt252Dict<bool>
}