use crowdfunding::crowdfunding::{ICrowdfundingDispatcher, ICrowdfundingDispatcherTrait};
use super::common::{deployCrowdfundingContract};
use starknet::{ContractAddress, contract_address_const};

#[test]
fn test_contract_deployment() {
    let manager = contract_address_const::<'owner'>();
    let minimumContribution: usize = 10;
    let (crowdfunding, _) = deployCrowdfundingContract(manager, minimumContribution);

    assert_eq!(crowdfunding.getManager(), manager);
    assert_eq!(crowdfunding.getMinimumContribution(), minimumContribution);
}