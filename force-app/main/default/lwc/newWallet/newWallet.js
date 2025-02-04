import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import WALLET from '@salesforce/schema/Wallet__c';
import ACCOUNT_TYPE from '@salesforce/schema/Wallet__c.AccountType__c';
import BLOCKCHAIN from '@salesforce/schema/Wallet__c.Blockchain__c';
import CIRCLE_NAME from '@salesforce/schema/Wallet__c.CircleName__c';
import WALLETSET from '@salesforce/schema/Wallet__c.WalletSet__c';

import { labels } from './labels';
import { TOAST_VARIANT, TOAST_MODE } from 'c/constants';
import { encryptData } from 'c/programmableWalletsSetup';

import getSetup from '@salesforce/apex/NewWalletCtrl.getSetup';
import createWallet from '@salesforce/apex/NewWalletCtrl.createWallet';

import circleLogo from '@salesforce/contentAssetUrl/CircleLogo';

export default class NewWallet extends NavigationMixin(LightningElement) {
    @api recordId;

    @track
    setupData = {};
    @track
    wallet = {};

    labels = labels;
    logo = circleLogo;
    objects = {
        WALLET: WALLET
    };
    fields = {
        ACCOUNT_TYPE: ACCOUNT_TYPE,
        BLOCKCHAIN: BLOCKCHAIN,
        CIRCLE_NAME: CIRCLE_NAME,
        WALLETSET: WALLETSET
    };

    isLoading = false;
    walletRecordId;

    get isCreateDisabled() {
        return (
            !this.wallet[ACCOUNT_TYPE.fieldApiName] ||
            !this.wallet[BLOCKCHAIN.fieldApiName] ||
            !this.wallet[CIRCLE_NAME.fieldApiName] ||
            !this.wallet[WALLETSET.fieldApiName]
        );
    }

    redirectToRecordList() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: WALLET.objectApiName,
                actionName: 'list'
            }
        });
    }

    redirectToRecord() {
        if (this.walletRecordId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.walletRecordId,
                    actionName: 'view'
                }
            });
        }
    }

    handleFieldChange(event) {
        this.wallet[event.target.fieldName] = event.detail.value;
    }

    handleClose() {
        this.redirectToRecordList();
    }

    async handleCreateWallet() {
        this.isLoading = true;
        try {
            const entitySecretCiphertext = await encryptData(this.setupData.entityPublicKey, this.setupData.entitySecret);
            const walletData = {
                accountType: this.wallet[ACCOUNT_TYPE.fieldApiName],
                blockchain: this.wallet[BLOCKCHAIN.fieldApiName],
                circleName: this.wallet[CIRCLE_NAME.fieldApiName],
                walletSetId: this.wallet[WALLETSET.fieldApiName][0]
            };

            this.walletRecordId = await createWallet({
                walletData: walletData,
                entitySecretCipher: entitySecretCiphertext
            });

            this.showToast(this.labels.CORE.Create_Success, this.labels.CORE.Create_Success_Message, TOAST_VARIANT.SUCCESS, TOAST_MODE.SUCCESS);

            this.redirectToRecord();
        } catch (error) {
            const erroMessage = error.body ? error.body.message : error.message;
            this.showToast(erroMessage);
        } finally {
            this.isLoading = false;
        }
    }

    async connectedCallback() {
        this.isLoading = true;
        try {
            this.wallet = {
                [ACCOUNT_TYPE.fieldApiName]: null,
                [BLOCKCHAIN.fieldApiName]: null,
                [CIRCLE_NAME.fieldApiName]: null,
                [WALLETSET.fieldApiName]: null
            };
            const result = await getSetup();
            Object.assign(this.setupData, result);
        } catch (error) {
            const erroMessage = error.body ? error.body.message : error.message;
            this.showToast(erroMessage);
        } finally {
            this.isLoading = false;
        }
    }

    showToast(title, message, type = TOAST_VARIANT.ERROR, mode = TOAST_MODE.ERROR) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: type,
                mode: mode
            })
        );
    }
}
