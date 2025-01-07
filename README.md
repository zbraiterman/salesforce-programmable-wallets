# Salesforce Programmable Wallets

![](https://github.com/MuKnSys/web3-wallet-for-salesforce/blob/main/documentation-and-images/Web3-wallet-for-Salesforce-logo.png)

Programmable Wallets for Salesforce, powered by Circle programmable wallets, is an open source solution built on Circle Programmable Wallet technology to operating 100% within the Salesfore Ecosystem.

Key management is abstracted as Developmer Managed Wallets, using Salesforce permissions to manage wallet safety. The company will be able to grant read, write, and execute permissions on the Web3 assets without leaving the environment they are comfortable with.


## Ssalesforce DX Project Setup Information

This is a basic demonstration Salesforce DX Project. Using the
[SF CLI](https://developer.salesforce.com/tools/sfdxcli) tools, you can deploy
to a Developer Edition Scratch Org.

Now that you’ve created a Salesforce DX project, what’s next? Here are some
documentation resources to get you started.

## Salesforce Developer Edition

You can get a free Salesforce Developer Edition account from Salesforce. Sign up
at:

https://developer.salesforce.com/signup

## How To Test the App - Using Repository

1. Fetch the repository
1. Checkout the main branch
1. Log into the Dev Hub Org by running
   `sf org login web --set-default-dev-hub --alias DevHub --instance-url https://login.salesforce.com`
   and entering your username and password.
1. Create a Scratch Org by running
   `sf org create scratch -f ./config/project-scratch-def.json -a dev -d -y 30`.
   - The `-f` flag is a path to config file (no need to change it).
   - The `-a` flag is an alias of the scratch org, if you create multiple
     scratch orgs you can give them unique aliases to easier refer to them.
   - The `-d` flag marks the newly created scratch org as default. If you don't
     mark it as default you will have to reference it by username or alias, or
     you will have to use `sf config set target-org YourAliasOrUsername` to set
     is as default.
   - The `-y` flag sets the number of days before the org expires.
   - Use the `-h` flag for help.
   - For more details:
     [developer docs scratch orgs create](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_scratch_orgs_create.htm).
1. Push the code to the Scratch Org: `sf project deploy start`
1. Connect to the Salesforce Scratch Org: `sf org open`

## Usage - Milestone 1

1. Assign permission set: `Salesforce Programmable Wallets Admin` to your user
1. Use App Launcher to open `Programmable Wallets Setup`.
1. Please perform all the setup steps.

## Submitting changes to GitHub

1. Create a feature / change branch - you will need to fork the project
1. Pull changes from Salesforce `sf project retrieve start`
1. Push changes to GitHub
1. Create a pull request


## Copyright and License

Copyright 2024 Web3 Enabler, Inc. Web3 Wallet for Salesforce is distributed under the GPL licence, version 3.0. For more information, see the [LICENSE file](https://github.com/MuKnSys/web3-wallet-for-salesforce/blob/main/LICENSE).
