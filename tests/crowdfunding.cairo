use crowdfunding::crowdfunding::{
    Crowdfunding, ICrowdfundingDispatcher, ICrowdfundingDispatcherTrait
};
use super::common::{deployCrowdfundingContract};
<<<<<<< HEAD
use starknet::{ContractAddress, contract_address_const};
=======
use starknet::{ContractAddress, contract_address_const, get_caller_address};
>>>>>>> 6864bf0499b49160ef616bd6b4556e60f32d8643
use snforge_std::{load, map_entry_address};

#[test]
fn test_contract_deployment() {
    let manager = contract_address_const::<'manager'>();
    let notManager = contract_address_const::<'not-manager'>();
    let minimumContribution: usize = 10;

    let (_, crowdfundingAddress) = deployCrowdfundingContract(manager, minimumContribution);

    let managerInContract = load(crowdfundingAddress, selector!("manager"), 1);
    let minimumContributionInContract = load(crowdfundingAddress, selector!("minimumContribution"), 1);
    
    assert_eq!(*managerInContract.at(0), manager.into());
    assert_ne!(*managerInContract.at(0), notManager.into());
    assert_eq!(*minimumContributionInContract.at(0), minimumContribution.into());
    assert_ne!(*minimumContributionInContract.at(0), 20);
}

#[test]
fn it_should_allow_people_to_contribute_money_and_marks_them_as_approvers() {
    let manager = contract_address_const::<'manager'>();
    let caller = get_caller_address();
    let minimumContribution: usize = 10;
<<<<<<< HEAD
    let (crowdfunding, crowdfundingAddress) = deployCrowdfundingContract(manager, minimumContribution);

    crowdfunding.contribute(minimumContribution);

    let isApprover = load(crowdfundingAddress, map_entry_address(
        selector!("approvers"),
        array![manager.into() ].span()
    ),1);

=======
    let contribution = 15;
    let (crowdfunding, crowdfundingAddress) = deployCrowdfundingContract(manager, minimumContribution);

    crowdfunding.contribute(contribution);

    let isApprover = load(crowdfundingAddress, map_entry_address(
        selector!("approvers"),
        array![caller.into()].span()
    ),1);

>>>>>>> 6864bf0499b49160ef616bd6b4556e60f32d8643
    assert_eq!(*isApprover.at(0), true.into());
}