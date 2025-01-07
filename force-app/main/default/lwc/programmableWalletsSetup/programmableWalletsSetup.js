import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { labels } from './labels';
import { TOAST_VARIANT, TOAST_MODE, STEPS } from 'c/constants';

import getSetup from '@salesforce/apex/ProgrammableWalletsSetupCtrl.getSetup';
import removeConfig from '@salesforce/apex/ProgrammableWalletsSetupCtrl.removeConfig';
import saveSettings from '@salesforce/apex/ProgrammableWalletsSetupCtrl.saveSettings';
import generateEnitySecret from '@salesforce/apex/ProgrammableWalletsSetupCtrl.generateEnitySecret';
import generateEnityPublicKey from '@salesforce/apex/ProgrammableWalletsSetupCtrl.generateEnityPublicKey';
import completeConsoleRegistered from '@salesforce/apex/ProgrammableWalletsSetupCtrl.completeConsoleRegistered';

import CircleLogo from '@salesforce/contentAssetUrl/CircleLogo';

import { encryptData } from './encryption';

export default class ProgrammableWalletsSetup extends LightningElement {
    isLoading = true;
    labels = labels;
    steps = STEPS;
    logo = CircleLogo;
    circleApiKeyURL = 'https://developers.circle.com/interactive-quickstarts/get-started#create-your-api-key';
    circleRegisteringURL = 'https://console.circle.com/wallets/dev/configurator';

    @track
    setupData = {};
    apiKey;

    completedSectionToAvailableSteps = {
        apiKey: this.steps.n2,
        entitySecret: this.steps.n3,
        entityPublicKey: this.steps.n4,
        entitySecretCiphertext: this.steps.n5
    };

    get activeSections() {
        const sections = Object.keys(this.setupData).map(section => {
            if (!this.isBlank(this.setupData, section)) {
                return this.completedSectionToAvailableSteps[section];
            }
        });

        return [this.steps.n1].concat(sections);
    }

    get apiKeyCompleted() {
        return !this.isBlank(this.setupData, 'apiKey');
    }

    get entitySecretCompleted() {
        return !this.isBlank(this.setupData, 'entitySecret');
    }

    get entityPublicKeyCompleted() {
        return !this.isBlank(this.setupData, 'entityPublicKey');
    }

    get entitySecretCiphertextCompleted() {
        return !this.isBlank(this.setupData, 'entitySecretCiphertext');
    }

    isBlank(object, value) {
        return !(value in object && object[value] !== undefined && object[value] !== null && object[value] !== '');
    }

    async loadSetup() {
        const result = await getSetup();
        this.processSetupData(result);
    }

    processSetupData(value) {
        Object.assign(this.setupData, value);
    }

    async handleRefresh() {
        this.isLoading = true;
        try {
            await this.loadSetup();
        } catch (error) {
            const erroMessage = error.body ? error.body.message : error.message;
            this.showToast(erroMessage);
        } finally {
            this.isLoading = false;
        }
    }

    async handleRemoveConfig() {
        this.isLoading = true;
        try {
            const result = await removeConfig();
            this.processSetupData(result);
        } catch (error) {
            const erroMessage = error.body ? error.body.message : error.message;
            this.showToast(erroMessage);
        } finally {
            this.isLoading = false;
        }
    }

    handleApiKey(event) {
        this.apiKey = event.detail.value;
    }

    async handleApiKeyStorage() {
        if (!this.apiKey) {
            return;
        }

        this.isLoading = true;
        try {
            const result = await saveSettings({
                data: {
                    apiKey: this.apiKey
                }
            });
            this.processSetupData(result);
            this.apiKey = null;

            this.showToast(this.labels.CORE.Success, this.labels.CORE.Success_Info, TOAST_VARIANT.SUCCESS, TOAST_MODE.SUCCESS);
        } catch (error) {
            const erroMessage = error.body ? error.body.message : error.message;
            this.showToast(erroMessage);
        } finally {
            this.isLoading = false;
        }
    }

    async handleEntitySecret() {
        this.isLoading = true;
        try {
            const result = await generateEnitySecret();
            this.processSetupData(result);

            this.showToast(this.labels.CORE.Success, this.labels.CORE.Success_Info, TOAST_VARIANT.SUCCESS, TOAST_MODE.SUCCESS);
        } catch (error) {
            const erroMessage = error.body ? error.body.message : error.message;
            this.showToast(erroMessage);
        } finally {
            this.isLoading = false;
        }
    }

    async handlePublicEntityKey() {
        this.isLoading = true;
        try {
            const result = await generateEnityPublicKey();
            this.processSetupData(result);

            this.showToast(this.labels.CORE.Success, this.labels.CORE.Success_Info, TOAST_VARIANT.SUCCESS, TOAST_MODE.SUCCESS);
        } catch (error) {
            const erroMessage = error.body ? error.body.message : error.message;
            this.showToast(erroMessage);
        } finally {
            this.isLoading = false;
        }
    }

    async handleEncryption() {
        this.isLoading = true;
        try {
            const entitySecretCiphertext = await encryptData(this.setupData.entityPublicKey, this.setupData.entitySecret);
            const result = await saveSettings({
                data: {
                    entitySecretCiphertext: entitySecretCiphertext
                }
            });
            this.processSetupData(result);

            this.showToast(this.labels.CORE.Success, this.labels.CORE.Success_Info, TOAST_VARIANT.SUCCESS, TOAST_MODE.SUCCESS);
        } catch (error) {
            const erroMessage = error.body ? error.body.message : error.message;
            this.showToast(erroMessage);
        } finally {
            this.isLoading = false;
        }
    }

    async handleRegisterComplete() {
        this.isLoading = true;
        try {
            const result = await completeConsoleRegistered();
            this.processSetupData(result);

            this.showToast(this.labels.CORE.Success, this.labels.CORE.Success_Info, TOAST_VARIANT.SUCCESS, TOAST_MODE.SUCCESS);
        } catch (error) {
            const erroMessage = error.body ? error.body.message : error.message;
            this.showToast(erroMessage);
        } finally {
            this.isLoading = false;
        }
    }

    async connectedCallback() {
        try {
            await this.loadSetup();
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
