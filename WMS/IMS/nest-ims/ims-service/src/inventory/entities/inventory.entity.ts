import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity()
export class Inventory {
  @PrimaryGeneratedColumn()
  itemId: number;

  @Column()
  productId: string;

  @Column()
  quantity: number;

  @Column()
  location: string;

  @CreateDateColumn()
  createdAt: Date;
}
