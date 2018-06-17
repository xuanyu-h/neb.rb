# encoding: utf-8
# frozen_string_literal: true

module Neb
  class DeprecatedError < StandardError; end
  class InvalidJSONKeyError < StandardError; end
  class ChecksumError < StandardError; end
  class FormatError < StandardError; end
  class ValidationError < StandardError; end
  class ValueError < StandardError; end
  class AssertError < StandardError; end
  class UnsignError < StandardError; end

  class UnknownParentError < StandardError; end
  class InvalidBlock < ValidationError; end
  class InvalidUncles < ValidationError; end

  class InvalidTransaction < ValidationError; end
  class UnsignedTransactionError < InvalidTransaction; end
  class InvalidNonce < InvalidTransaction; end
  class InsufficientStartGas < InvalidTransaction; end
  class InsufficientBalance < InvalidTransaction; end
  class BlockGasLimitReached < InvalidTransaction; end

  class InvalidSPVProof < ValidationError; end

  class ContractCreationFailed < StandardError; end
  class TransactionFailed < StandardError; end
end
