use starknet::{ContractAddress, contract_address_const};

#[derive(Copy, Clone, Drop)]
pub enum ADDRESSES {
  CALLER,
  SPONSOR,
  SUPPLIER,
}

#[generate_trait]
pub impl ADDRESSESImpl of ADDRESSESTrait {
  fn get(self: @ADDRESSES) -> ContractAddress {
    match self {
      ADDRESSES::CALLER => contract_address_const::<'caller'>(),
      ADDRESSES::SPONSOR => contract_address_const::<'sponsor'>(),
      ADDRESSES::SUPPLIER => contract_address_const::<'supplier'>(),
    }
  }
}