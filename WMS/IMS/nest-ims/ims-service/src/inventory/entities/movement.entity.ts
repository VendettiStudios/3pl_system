import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  ManyToOne,
} from 'typeorm';
import { Inventory } from './inventory.entity';

@Entity()
export class Movement {
  @PrimaryGeneratedColumn()
  movementId: number;

  @ManyToOne(() => Inventory, (inventory) => inventory.itemId)
  itemId: number;

  @Column()
  quantity: number;

  @Column()
  fromLocation: string;

  @Column()
  toLocation: string;

  @CreateDateColumn()
  movementDate: Date;
}
