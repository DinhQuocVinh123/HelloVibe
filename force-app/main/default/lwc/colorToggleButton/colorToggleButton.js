import { LightningElement } from 'lwc';

export default class ColorToggleButton extends LightningElement {
    isPrimary = true;

    get boxClass() {
        return this.isPrimary ? 'box box--primary' : 'box box--secondary';
    }

    handleToggle() {
        this.isPrimary = !this.isPrimary;
    }
}
