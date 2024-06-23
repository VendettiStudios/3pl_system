import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Inventory } from './entities/inventory.entity';
import { Movement } from './entities/movement.entity';
import { CreateInventoryDto } from './dto/create-inventory.dto';
import { RecordMovementDto } from './dto/record-movement.dto';

@Injectable()
export class InventoryService {
  constructor(
    @InjectRepository(Inventory)
    private inventoryRepository: Repository<Inventory>,
    @InjectRepository(Movement)
    private movementRepository: Repository<Movement>,
  ) {}

  async create(createInventoryDto: CreateInventoryDto): Promise<Inventory> {
    const newItem = this.inventoryRepository.create(createInventoryDto);
    return this.inventoryRepository.save(newItem);
  }

  async recordMovement(
    recordMovementDto: RecordMovementDto,
  ): Promise<Movement> {
    const newMovement = this.movementRepository.create(recordMovementDto);
    return this.movementRepository.save(newMovement);
  }

  async findAll(): Promise<Inventory[]> {
    return this.inventoryRepository.find();
  }

  async findOne(id: number): Promise<Inventory> {
    return this.inventoryRepository.findOneBy({ itemId: id });
  }
}
