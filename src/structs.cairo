use starknet::ContractAddress;

pub struct Summary {
    minimumContribution: usize,
    balance: usize,
    numberOfRequests: u16,
    numberOfApprovers: u16,
    managerAddress: ContractAddress
}

pub struct Request {
    description: ByteArray,
    value: usize,
    recipient: ContractAddress,
    isComplete: bool,
    yesVotes: usize,
    voters: Felt252Dict<bool>
}