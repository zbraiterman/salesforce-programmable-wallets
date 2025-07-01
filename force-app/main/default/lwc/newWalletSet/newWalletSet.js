import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import WALLET_SET from '@salesforce/schema/WalletSet__c';
import NAME from '@salesforce/schema/WalletSet__c.CircleName__c';

import { labels } from './labels';
import { TOAST_VARIANT, TOAST_MODE } from 'c/constants';
import { encryptData } from 'c/programmableWalletsSetup';

import getSetup from '@salesforce/apex/NewWalletSetCtrl.getSetup';
import createWalletSet from '@salesforce/apex/NewWalletSetCtrl.createWalletSet';

import circleLogo from '@salesforce/contentAssetUrl/CircleLogo';

export default class NewWalletSet extends NavigationMixin(LightningElement) {
    @api recordId;

    @track
    setupData = {};
    @track
    walletSet = {};

    labels = labels;
    logo = circleLogo;
    objects = {
        WALLET_SET: WALLET_SET
    };
    fields = {
        NAME: NAME
    };

    isLoading = false;
    walletSetRecordId;

    get isCreateDisabled() {
        return !this.walletSet[NAME.fieldApiName];
    }

    redirectToRecordList() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: WALLET_SET.objectApiName,
                actionName: 'list'
            }
        });
    }

    redirectToRecord() {
        if (this.walletSetRecordId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.walletSetRecordId,
                    actionName: 'view'
                }
            });
        }
    }

    handleFieldChange(event) {
        this.walletSet[event.target.fieldName] = event.detail.value;
    }

    handleClose() {
        this.redirectToRecordList();
    }

    async handleCreateWalletSet() {
        this.isLoading = true;
        try {
            const entitySecretCiphertext = await encryptData(this.setupData.entityPublicKey, this.setupData.entitySecret);

            this.walletSetRecordId = await createWalletSet({
                walletSetName: this.walletSet[NAME.fieldApiName],
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
            this.walletSet = {
                [NAME.fieldApiName]: null
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
