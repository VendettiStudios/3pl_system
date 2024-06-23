// src/inventory/dto/record-movement.dto.ts
export class RecordMovementDto {
  itemId: number;
  quantity: number;
  fromLocation: string;
  toLocation: string;
}
