use openzeppelin::utils::serde::SerializedAppend;
use crowdfunding::crowdfunding::{ICrowdfundingDispatcher};
use starknet::{ContractAddress};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};


pub fn deployCrowdfundingContract(manager: ContractAddress, minimumContribution: usize) -> (ICrowdfundingDispatcher, ContractAddress) {
    let crowdfunding_clash_hash = declare("Crowdfunding").unwrap().contract_class();

    let mut constructor_calldata: Array<felt252> = array![];
    constructor_calldata.append_serde(manager);
    constructor_calldata.append_serde(minimumContribution);

    let (crowdfunding_contract_address, _) = crowdfunding_clash_hash.deploy(@constructor_calldata).unwrap();
    let crowdfunding_dispatch = ICrowdfundingDispatcher { contract_address: crowdfunding_contract_address };

    println!("Crowdfunding contract deployed at address: {:?}", crowdfunding_contract_address);

    (crowdfunding_dispatch, crowdfunding_contract_address)
}