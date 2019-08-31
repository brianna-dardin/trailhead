global class ScheduleEquipmentCallout implements Schedulable {
    global void execute(SchedulableContext ctx) {
        EquipmentCallout.getEquipment();
    }
}