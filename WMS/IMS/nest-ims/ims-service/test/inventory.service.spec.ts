// ims-service/test/inventory.service.spec.ts
import { Test, TestingModule } from '@nestjs/testing';
import { InventoryService } from '../src/inventory/inventory.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Inventory } from '../src/inventory/entities/inventory.entity';
import { Movement } from '../src/inventory/entities/movement.entity';

describe('InventoryService', () => {
  let service: InventoryService;
  let inventoryRepository: Repository<Inventory>;
  let movementRepository: Repository<Movement>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        InventoryService,
        {
          provide: getRepositoryToken(Inventory),
          useClass: Repository,
        },
        {
          provide: getRepositoryToken(Movement),
          useClass: Repository,
        },
      ],
    }).compile();

    service = module.get<InventoryService>(InventoryService);
    inventoryRepository = module.get<Repository<Inventory>>(
      getRepositoryToken(Inventory),
    );
    movementRepository = module.get<Repository<Movement>>(
      getRepositoryToken(Movement),
    );
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create an inventory item', async () => {
    const createInventoryDto = {
      productId: '123',
      quantity: 10,
      location: 'A1',
    };
    const inventoryItem = new Inventory();
    inventoryItem.productId = '123';
    inventoryItem.quantity = 10;
    inventoryItem.location = 'A1';

    jest.spyOn(inventoryRepository, 'save').mockResolvedValue(inventoryItem);

    expect(await service.create(createInventoryDto)).toEqual(inventoryItem);
  });

  it('should record a movement', async () => {
    const recordMovementDto = {
      itemId: 1,
      quantity: 5,
      fromLocation: 'A1',
      toLocation: 'B1',
    };
    const movement = new Movement();
    movement.itemId = 1;
    movement.quantity = 5;
    movement.fromLocation = 'A1';
    movement.toLocation = 'B1';

    jest.spyOn(movementRepository, 'save').mockResolvedValue(movement);

    expect(await service.recordMovement(recordMovementDto)).toEqual(movement);
  });
});
