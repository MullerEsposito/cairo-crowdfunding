use crowdfunding::crowdfunding::{ICrowdfundingDispatcher, ICrowdfundingDispatcherTrait};
use super::common::{deployContract};
use starknet::{ContractAddress};

#[test]
fn test_contract_deployment() {
    let (crowdfunding, _, owner) = deployContract();

    assert_eq!(crowdfunding.getManager(), owner);
}