import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { Tag } from 'primeng/tag';

@Component({
  imports: [RouterOutlet, Tag],
  selector: 'app-root',
  styleUrl: './app.scss',
  templateUrl: './app.html',
})
export class App {}
