use crowdfunding::crowdfunding::{Crowdfunding, ICrowdfundingDispatcher};
use starknet::{ContractAddress, contract_address_const};
use snforge_std::{declare, ContractClassTrait};


pub fn deployCrowdfundingContract(manager: ContractAddress, minimumContribution: usize) -> (ICrowdfundingDispatcher, ContractAddress) {
    let contract = declare("Crowdfunding").unwrap();

    let mut constructor_calldata = array![manager.into(), minimumContribution.into()];

    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();
    let dispatch = ICrowdfundingDispatcher { contract_address };

    (dispatch, contract_address)
}