# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheet::AttributesGroup, type: :model do
  context 'Game System' do
    let(:system) { load_system }

    it 'serializes the group "Dados"' do
      group = system.sheet.attributes_groups.first

      expect(group.name).to eq('Dados')
      expect(group.page).to eq(1)
      expect(group.order).to eq(1)
      expect(group.type).to eq('character_card')
      expect(group.position).to eq('header')
      expect(group.source_type).to eq('fixed')
      expect(group.show_on_posts?).to be false
      expect(group.instructions).not_to be_blank
      expect(group.character_attributes.count).to eq(12)
    end

    it 'serializes the group "Dados Extras"' do
      group = system.sheet.attributes_groups[1]

      expect(group.name).to eq('Dados Extras')
      expect(group.page).to eq(1)
      expect(group.order).to eq(2)
      expect(group.type).to eq('table')
      expect(group.position).to eq('column_2')
      expect(group.source_type).to eq('table')
      expect(group.show_on_posts?).to be false
      expect(group.instructions).to be_blank
      expect(group.character_attributes.count).to eq(4)
    end

    it 'serializes the group "Atributos"' do
      group = system.sheet.attributes_groups[2]

      expect(group.name).to eq('Atributos')
      expect(group.page).to eq(1)
      expect(group.order).to eq(1)
      expect(group.type).to eq('name_value')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('fixed')
      expect(group.show_on_posts?).to be false
      expect(group.order_on_posts).to eq(1)
      expect(group.instructions).not_to be_blank
      expect(group.attributes_points_formula).to eq('4 * points')
      expect(group.group_points_formula).to eq('100 + dados=>nivel')
      expect(group.character_attributes.count).to eq(8)
    end

    it 'serializes the group "Perícias"' do
      group = system.sheet.attributes_groups[3]

      expect(group.name).to eq('Perícias')
      expect(group.page).to eq(1)
      expect(group.order).to eq(1)
      expect(group.type).to eq('based')
      expect(group.position).to eq('column_2')
      expect(group.source_type).to eq('list')
      expect(group.show_on_posts?).to be false
      expect(group.instructions).not_to be_blank
      expect(group.attributes_points_formula).to be_nil
      expect(group.group_points_formula).to eq('10 * dados=>idade + 5 * atributos=>inteligencia')
      expect(group.character_attributes.count).to eq(0)
      expect(group.list.count).to eq(15)
    end

    it 'serializes the group "Aprimoramentos"' do
      group = system.sheet.attributes_groups[4]

      expect(group.name).to eq('Aprimoramentos')
      expect(group.page).to eq(1)
      expect(group.order).to eq(2)
      expect(group.type).to eq('name_value')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('list')
      expect(group.show_on_posts?).to be false
      expect(group.instructions).not_to be_blank
      expect(group.attributes_points_formula).to be_nil
      expect(group.group_points_formula).to eq('5 + floor(dados=>nivel / 3)')
      expect(group.character_attributes.count).to eq(0)
      expect(group.list.count).to eq(13)
    end

    it 'serializes the group "Itens"' do
      group = system.sheet.attributes_groups[5]

      expect(group.name).to eq('Itens')
      expect(group.page).to eq(2)
      expect(group.order).to eq(1)
      expect(group.type).to eq('text')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('open')
      expect(group.show_on_posts?).to be false
      expect(group.instructions).to be_blank
      expect(group.attributes_points_formula).to be_nil
      expect(group.character_attributes.count).to eq(0)
    end

    it 'serializes the group "História"' do
      group = system.sheet.attributes_groups[6]

      expect(group.name).to eq('História')
      expect(group.page).to eq(3)
      expect(group.order).to eq(1)
      expect(group.type).to eq('rich_text')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('open')
      expect(group.show_on_posts?).to be false
      expect(group.instructions).not_to be_blank
      expect(group.character_attributes.count).to eq(1)
    end

    it 'serializes the group "Status"' do
      group = system.sheet.attributes_groups[7]

      expect(group.name).to eq('Status')
      expect(group.page).to eq(1)
      expect(group.order).to eq(3)
      expect(group.type).to eq('mixed')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('fixed')
      expect(group.show_on_posts?).to be true
      expect(group.order_on_posts).to eq(1)
      expect(group.instructions).to be_blank
      expect(group.character_attributes.count).to eq(6)
    end

    it 'serializes the group "Grimório"' do
      group = system.sheet.attributes_groups[8]

      expect(group.name).to eq('Grimório')
      expect(group.page).to eq(2)
      expect(group.order).to eq(2)
      expect(group.type).to eq('text')
      expect(group.position).to eq('column_2')
      expect(group.source_type).to eq('list')
      expect(group.show_on_posts?).to be false
      expect(group.instructions).to be_blank
      expect(group.character_attributes.count).to eq(0)
      expect(group.list.count).to eq(7)
    end

    it 'serializes the group "Equipamentos"' do
      group = system.sheet.attributes_groups.last

      expect(group.name).to eq('Equipamentos')
      expect(group.page).to eq(2)
      expect(group.order).to eq(1)
      expect(group.type).to eq('equipments')
      expect(group.position).to eq('column_2')
      expect(group.source_type).to eq('equipments')
      expect(group.show_on_posts?).to be false
      expect(group.instructions).to be_blank
      expect(group.character_attributes).to be_nil
      expect(group.equipments.count).to eq(11)
    end
  end

  context 'Character Sheet' do
    before(:all) do
      @sheet = load_sheet('crossover', 'inuyasha')
    end

    # FIXME: what is this test testing?
    it 'serializes the equipments' do
      expect(@sheet.attributes_groups.count).to eq(10)
    end
  end

  describe '#used_points' do
    it 'returns zero then there are no list' do
      attributes_group = Sheet::AttributesGroup.new()
      expect(attributes_group.used_points).to eq(0)
    end

    it 'returns zero then there are no attributes on the list' do
      attributes_group = Sheet::AttributesGroup.new(character_attributes: [])
      expect(attributes_group.used_points).to eq(0)
    end

    it 'sums the points of all attributes on the list' do
      attributes = [
        { name: 'Força', points: 10 },
        { name: 'Constituição', points: 12 },
        { name: 'Destreza', points: 7 },
        { name: 'Agilidade', points: 5 },
        { name: 'Inteligência', points: 17 },
        { name: 'Força de vontade', points: 21 },
        { name: 'Percepção', points: 12 },
        { name: 'Carisma', points: 10 }
      ]
      attributes_group = Sheet::AttributesGroup.new(character_attributes: attributes, group_points_formula: '100')
      expect(attributes_group.used_points).to eq(94)
    end

    it 'sums the points considering nil as zero' do
      attributes = [
        { name: 'Força', points: 10  },
        { name: 'Constituição' }
      ]
      attributes_group = Sheet::AttributesGroup.new(character_attributes: attributes, group_points_formula: '100')
      expect(attributes_group.used_points).to eq(10)
    end
  end

  describe '#total_points' do
    it 'returns the points of the group if no extra points are provided' do
      attributes_group = Sheet::AttributesGroup.new(points: 20)
      expect(attributes_group.total_points).to eq(20)
    end

    it 'sums the points with extra_points' do
      attributes_group = Sheet::AttributesGroup.new(points: 20, extra_points: 5)
      expect(attributes_group.total_points).to eq(25)
    end
  end

  describe '#to_params' do
    let(:attribute_group) do
      Sheet::AttributesGroup.new(
        name: 'Group',
        extra_points: 10,
        group_points_formula: '100',
        source_type: 'list',
        type: 'list',
        character_attributes: [
          { name: 'attribute 1', points: 10 },
          { name: 'attribute 1', points: 25 }
        ]
      )
    end

    context 'without custom params' do
      it 'transforms the group in a hash params' do
        expected = {
          group_name: 'Group',
          points: nil,
          used_points: 35,
          source_type: 'list',
          type: 'list'
        }
        expect(attribute_group.to_params).to eq(expected)
      end
    end

    context 'with custom params' do
      it 'transforms the group in a hash params' do
        expected = {
          group_name: 'Group',
          points: nil,
          used_points: 35,
          source_type: 'list',
          type: 'list',
          editable_only_on_free_mode: true
        }
        expect(attribute_group.to_params(editable_only_on_free_mode: true)).to eq(expected)
      end
    end
  end
end
