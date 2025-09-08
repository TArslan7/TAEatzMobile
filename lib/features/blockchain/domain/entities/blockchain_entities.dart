import 'package:equatable/equatable.dart';

// Cryptocurrency Payment Entity
class CryptocurrencyPaymentEntity extends Equatable {
  final String id;
  final String userId;
  final String orderId;
  final String currency; // 'BTC', 'ETH', 'USDC', 'USDT'
  final double amount;
  final String walletAddress;
  final String transactionHash;
  final String status; // 'pending', 'confirmed', 'failed', 'refunded'
  final int confirmations;
  final double gasFee;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final Map<String, dynamic> metadata;

  const CryptocurrencyPaymentEntity({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.currency,
    required this.amount,
    required this.walletAddress,
    required this.transactionHash,
    required this.status,
    required this.confirmations,
    required this.gasFee,
    required this.createdAt,
    this.confirmedAt,
    required this.metadata,
  });

  @override
  List<Object> get props => [id, userId, orderId, currency, amount, walletAddress, transactionHash, status, confirmations, gasFee, createdAt, confirmedAt, metadata];
}

// Loyalty Token Entity
class LoyaltyTokenEntity extends Equatable {
  final String id;
  final String userId;
  final String tokenType; // 'points', 'nft', 'utility_token'
  final String name;
  final String symbol;
  final double balance;
  final String contractAddress;
  final String tokenId;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  const LoyaltyTokenEntity({
    required this.id,
    required this.userId,
    required this.tokenType,
    required this.name,
    required this.symbol,
    required this.balance,
    required this.contractAddress,
    required this.tokenId,
    required this.metadata,
    required this.createdAt,
    this.lastUsedAt,
  });

  @override
  List<Object> get props => [id, userId, tokenType, name, symbol, balance, contractAddress, tokenId, metadata, createdAt, lastUsedAt];
}

// NFT Reward Entity
class NFTRewardEntity extends Equatable {
  final String id;
  final String userId;
  final String nftId;
  final String name;
  final String description;
  final String imageUrl;
  final String animationUrl;
  final String contractAddress;
  final String tokenId;
  final String rarity; // 'common', 'rare', 'epic', 'legendary'
  final Map<String, dynamic> attributes;
  final String status; // 'minted', 'claimed', 'transferred', 'burned'
  final DateTime createdAt;
  final DateTime? claimedAt;

  const NFTRewardEntity({
    required this.id,
    required this.userId,
    required this.nftId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.animationUrl,
    required this.contractAddress,
    required this.tokenId,
    required this.rarity,
    required this.attributes,
    required this.status,
    required this.createdAt,
    this.claimedAt,
  });

  @override
  List<Object> get props => [id, userId, nftId, name, description, imageUrl, animationUrl, contractAddress, tokenId, rarity, attributes, status, createdAt, claimedAt];
}

// Smart Contract Entity
class SmartContractEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String contractAddress;
  final String network; // 'ethereum', 'polygon', 'bsc', 'arbitrum'
  final String abi;
  final String bytecode;
  final String version;
  final bool isActive;
  final DateTime deployedAt;
  final DateTime updatedAt;

  const SmartContractEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.contractAddress,
    required this.network,
    required this.abi,
    required this.bytecode,
    required this.version,
    required this.isActive,
    required this.deployedAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id, name, description, contractAddress, network, abi, bytecode, version, isActive, deployedAt, updatedAt];
}

// Blockchain Transaction Entity
class BlockchainTransactionEntity extends Equatable {
  final String id;
  final String transactionHash;
  final String fromAddress;
  final String toAddress;
  final String network;
  final String type; // 'payment', 'token_transfer', 'nft_mint', 'contract_call'
  final double value;
  final String currency;
  final double gasUsed;
  final double gasPrice;
  final String status; // 'pending', 'confirmed', 'failed'
  final int blockNumber;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const BlockchainTransactionEntity({
    required this.id,
    required this.transactionHash,
    required this.fromAddress,
    required this.toAddress,
    required this.network,
    required this.type,
    required this.value,
    required this.currency,
    required this.gasUsed,
    required this.gasPrice,
    required this.status,
    required this.blockNumber,
    required this.timestamp,
    required this.metadata,
  });

  @override
  List<Object> get props => [id, transactionHash, fromAddress, toAddress, network, type, value, currency, gasUsed, gasPrice, status, blockNumber, timestamp, metadata];
}

// Wallet Entity
class WalletEntity extends Equatable {
  final String id;
  final String userId;
  final String address;
  final String network;
  final String walletType; // 'hot', 'cold', 'hardware'
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final Map<String, dynamic> metadata;

  const WalletEntity({
    required this.id,
    required this.userId,
    required this.address,
    required this.network,
    required this.walletType,
    required this.isActive,
    required this.createdAt,
    this.lastUsedAt,
    required this.metadata,
  });

  @override
  List<Object> get props => [id, userId, address, network, walletType, isActive, createdAt, lastUsedAt, metadata];
}

// DeFi Protocol Entity
class DeFiProtocolEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String protocolType; // 'lending', 'staking', 'yield_farming', 'liquidity_pool'
  final String contractAddress;
  final String network;
  final double apy; // Annual Percentage Yield
  final double tvl; // Total Value Locked
  final List<String> supportedTokens;
  final Map<String, dynamic> parameters;
  final bool isActive;

  const DeFiProtocolEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.protocolType,
    required this.contractAddress,
    required this.network,
    required this.apy,
    required this.tvl,
    required this.supportedTokens,
    required this.parameters,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, name, description, protocolType, contractAddress, network, apy, tvl, supportedTokens, parameters, isActive];
}

// Blockchain Network Entity
class BlockchainNetworkEntity extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final String rpcUrl;
  final String explorerUrl;
  final int chainId;
  final String currency;
  final double gasPrice;
  final int blockTime; // in seconds
  final bool isTestnet;
  final bool isActive;
  final Map<String, dynamic> metadata;

  const BlockchainNetworkEntity({
    required this.id,
    required this.name,
    required this.symbol,
    required this.rpcUrl,
    required this.explorerUrl,
    required this.chainId,
    required this.currency,
    required this.gasPrice,
    required this.blockTime,
    required this.isTestnet,
    required this.isActive,
    required this.metadata,
  });

  @override
  List<Object> get props => [id, name, symbol, rpcUrl, explorerUrl, chainId, currency, gasPrice, blockTime, isTestnet, isActive, metadata];
}

// Blockchain Analytics Entity
class BlockchainAnalyticsEntity extends Equatable {
  final String id;
  final String userId;
  final String metricType; // 'transaction_count', 'gas_spent', 'token_balance'
  final double value;
  final String period; // 'daily', 'weekly', 'monthly'
  final DateTime timestamp;
  final Map<String, dynamic> context;

  const BlockchainAnalyticsEntity({
    required this.id,
    required this.userId,
    required this.metricType,
    required this.value,
    required this.period,
    required this.timestamp,
    required this.context,
  });

  @override
  List<Object> get props => [id, userId, metricType, value, period, timestamp, context];
}

// Blockchain Error Entity
class BlockchainErrorEntity extends Equatable {
  final String id;
  final String userId;
  final String errorType; // 'transaction_failed', 'insufficient_gas', 'network_error'
  final String errorMessage;
  final String transactionHash;
  final Map<String, dynamic> context;
  final DateTime timestamp;

  const BlockchainErrorEntity({
    required this.id,
    required this.userId,
    required this.errorType,
    required this.errorMessage,
    required this.transactionHash,
    required this.context,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, userId, errorType, errorMessage, transactionHash, context, timestamp];
}
