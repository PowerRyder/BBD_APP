import {
  Component,
  Input,
  OnChanges,
  SimpleChanges,
  ElementRef,
  ViewChild,
  AfterViewInit,
  OnDestroy
} from '@angular/core';

declare const FlipDown: any;

@Component({
  selector: 'app-flip-clock',
  standalone: true,
  templateUrl: './flip-clock.component.html',
  styleUrls: ['./flip-clock.component.scss']
})
export class FlipClockComponent implements OnChanges, AfterViewInit, OnDestroy {

  @Input() targetDate!: Date;
  @Input() showUpto: 'days' | 'hours' | 'minutes' | 'seconds' = 'seconds';
  @Input() clockId: string = `flipdown-${Math.floor(Math.random() * 100000)}`;

  @ViewChild('flipdownContainer', { static: true }) containerRef!: ElementRef;

  private flipdownInstance: any;
  private viewInitialized = false;

  ngAfterViewInit(): void {
    this.viewInitialized = true;
    this.initFlipdown();
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['targetDate'] && this.viewInitialized) {
      this.initFlipdown();
    }
  }

  ngOnDestroy(): void {
    if (this.flipdownInstance && typeof this.flipdownInstance.stop === 'function') {
      this.flipdownInstance.stop();
    }
  }

  private initFlipdown(): void {
    if (!this.targetDate) {
      console.error('FlipClockComponent: No targetDate provided!');
      return;
    }

    const now = new Date().getTime() / 1000;
    const targetEpoch = this.targetDate.getTime() / 1000;

    const container = this.containerRef.nativeElement;
    container.innerHTML = ''; // Clear previous

    // Delay to ensure the container is in DOM
    setTimeout(() => {
      this.flipdownInstance = new FlipDown(targetEpoch, this.clockId)
        .start()
        .ifEnded(() => {
          console.log(`Countdown finished for ${this.clockId}`);
        });

      this.adjustVisibleUnits();
    }, 50);
  }

  private adjustVisibleUnits(): void {
    const flipdownElement = document.getElementById(this.clockId);
    if (!flipdownElement) return;

    const divs = flipdownElement.querySelectorAll('.rotor-group');

    switch (this.showUpto) {
      case 'days': break;
      case 'hours':
        divs[0]?.classList.add('d-none');
        break;
      case 'minutes':
        divs[0]?.classList.add('d-none');
        divs[1]?.classList.add('d-none');
        break;
      case 'seconds':
        divs[0]?.classList.add('d-none');
        divs[1]?.classList.add('d-none');
        divs[2]?.classList.add('d-none');
        break;
    }
  }
}
