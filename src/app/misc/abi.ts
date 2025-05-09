export let abi = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [],
		"name": "CreatorAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "sponsorAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "packageId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "Deposit",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "GetContractDetails",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "TotalCommunity",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "CommunityInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "CommunityWithdrawal",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "ContractBalance",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "InternalTokenTotalSupply",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "InternalTokenLiquidity",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "InternalTokenRate",
						"type": "uint256"
					}
				],
				"internalType": "struct DAppDemo.ContractInfo",
				"name": "info",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			}
		],
		"name": "GetDashboardDetails",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "DirectsCount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "ReferralIncome",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "LevelIncome",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "WithdrawalLevelIncome",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "TotalIncome",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "AmountWithdrawn",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "InternalTokenBalance",
						"type": "uint256"
					}
				],
				"internalType": "struct DAppDemo.UserDashboard",
				"name": "info",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "pageIndex",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "pageSize",
				"type": "uint256"
			}
		],
		"name": "GetDepositHistory",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "PackageId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Amount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "InternalTokenAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Rate",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Timestamp",
						"type": "uint256"
					}
				],
				"internalType": "struct DAppDemo.UserDeposit[]",
				"name": "deposits",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			}
		],
		"name": "GetDirects",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "Srno",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "Address",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "Investment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Business",
						"type": "uint256"
					}
				],
				"internalType": "struct DAppDemo.UserDirects[]",
				"name": "directs",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "pageIndex",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "pageSize",
				"type": "uint256"
			}
		],
		"name": "GetIncomeWithdrawalHistory",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "Amount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Timestamp",
						"type": "uint256"
					}
				],
				"internalType": "struct DAppDemo.UserIncomeWithdrawalTransaction[]",
				"name": "history",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			}
		],
		"name": "GetLevelIncomeInfo",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "Level",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredSelfInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "SelfInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredNumberOfDirects",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "DirectsCount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredDirectsInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "DirectsInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredNumberOfTeam",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "TotalTeam",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredTeamInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "TeamInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "OnAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Percentage",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Income",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "IsLevelAchieved",
						"type": "bool"
					}
				],
				"internalType": "struct DAppDemo.LevelIncomeInfo[]",
				"name": "info",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "GetPackages",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "PackageId",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "Name",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "Amount",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "IsActive",
						"type": "bool"
					},
					{
						"internalType": "bool",
						"name": "HasRange",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "MinAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "MaxAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "ReferralIncome",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "IsReferralIncomePercentage",
						"type": "bool"
					}
				],
				"internalType": "struct DAppDemo.PackageMaster[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "pageIndex",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "pageSize",
				"type": "uint256"
			}
		],
		"name": "GetTokenSellHistory",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "TokenAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "PaymentTokenAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Rate",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Timestamp",
						"type": "uint256"
					}
				],
				"internalType": "struct DAppDemo.UserTokenSellTransaction[]",
				"name": "history",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			}
		],
		"name": "GetWithdrawalLevelIncomeInfo",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "Level",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredSelfInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "SelfInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredNumberOfDirects",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "DirectsCount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredDirectsInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "DirectsInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredNumberOfTeam",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "TotalTeam",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "RequiredTeamInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "TeamInvestment",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "OnAmount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Percentage",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "Income",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "IsLevelAchieved",
						"type": "bool"
					}
				],
				"internalType": "struct DAppDemo.LevelIncomeInfo[]",
				"name": "info",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "LiquidityAmount_PaymentToken",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_address",
				"type": "address"
			}
		],
		"name": "Login",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "packageId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "Redeposit",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "userAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_type",
				"type": "uint256"
			}
		],
		"name": "SellTokens",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "TotalInvestment",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "TotalUsers",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "TotalWithdrawn",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "Withdraw",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "decimals",
		"outputs": [
			{
				"internalType": "uint8",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "map_LevelIncomeMaster",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "Level",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Percentage",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredSelfInvestment",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredNumberOfDirects",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredDirectsInvestment",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredNumberOfTeam",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredTeamInvestment",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "map_PackageMaster",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "PackageId",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "Name",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "Amount",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "IsActive",
				"type": "bool"
			},
			{
				"internalType": "bool",
				"name": "HasRange",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "MinAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "MaxAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "ReferralIncome",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "IsReferralIncomePercentage",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "map_UserBusinessOnLevel",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "map_UserDeposits",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "PackageId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Amount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "InternalTokenAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Rate",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Timestamp",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "map_UserIdToAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "map_UserIncome",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "ReferralIncome",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "AmountWithdrawn",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "map_UserIncomeWithdrawalHistory",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "Amount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Timestamp",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "map_UserTokenSellHistory",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "TokenAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "PaymentTokenAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Rate",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Timestamp",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "map_UserTransactionCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "DepositsCount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "TokenSellCount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "IncomeWithdrawalCount",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "map_UserWallet",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "CreditedIncome",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "DebitedIncome",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "map_UserWithdrawalOnLevel",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "map_Users",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "Id",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "Address",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "SponsorAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "JoiningTimestamp",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Investment",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "TeamInvestment",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "DirectsInvestment",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "TotalTeam",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "IsBlocked",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "LastTokenSellTimestamp",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RankId",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "map_WithdrawalLevelIncomeMaster",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "Level",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Percentage",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredSelfInvestment",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredNumberOfDirects",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredDirectsInvestment",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredNumberOfTeam",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "RequiredTeamInvestment",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "symbol",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]