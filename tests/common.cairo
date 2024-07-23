use crowdfunding::crowdfunding::{Crowdfunding, ICrowdfundingDispatcher};
use starknet::{ContractAddress, contract_address_const};
use snforge_std::{declare, ContractClassTrait};


pub fn deployContract() -> (ICrowdfundingDispatcher, ContractAddress, ContractAddress) {
    let contract = declare("Crowdfunding").unwrap();
    let owner = contract_address_const::<'owner'>();
    let minimumContribution: usize = 10;

    let mut constructor_calldata = array![owner.into(), minimumContribution.into()];

    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();
    let contract = ICrowdfundingDispatcher { contract_address };

    (contract, contract_address, owner)
}