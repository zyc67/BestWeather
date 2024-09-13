import { NinetyModel } from '../../models/NinetyDaysResp'

@Component
export struct NinetyCalendarView {
  @Prop @Watch('updateNinetyData') ninetyData: NinetyModel[]

  updateNinetyData() {

  }


  build() {
    Text(this.ninetyData.length.toString())
  }
}