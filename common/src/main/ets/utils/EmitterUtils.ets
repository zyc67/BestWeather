import { emitter } from '@kit.BasicServicesKit';

export function receiveEmitter(eventId: number, callback: Callback<emitter.EventData>) {
  const event: emitter.InnerEvent = { eventId };
  emitter.on(event, (res) => {
    callback(res)
  })
}

export function postEmitter(eventId: number, data?: emitter.EventData, priority?: emitter.EventPriority) {
    const event: emitter.InnerEvent = {
      eventId,
      priority: priority ?? emitter.EventPriority.LOW
    }
    emitter.emit(event, data)
}